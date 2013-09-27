#include <assert.h>
#ifdef __linux__
#undef  _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "patchlevel.h"

#include "../token.h"
#include "../lib.h"
#include "../symbol.h"
#include "const-c.inc"

#define TRACE(x) 
#define TRACE_ACTIVE()
#ifdef NDEBUG
#define assert_support(x)
#else
#define assert_support(x) x
#endif

static const char sparsepos_class[]  = "sparse::pos";
static const char sparsetok_class[]  = "sparse::tok";
static HV *sparsepos_class_hv;
static HV *sparsetok_class_hv;
static HV *sparsestash;


assert_support (static long sparsepos_count = 0;)
assert_support (static long sparsetok_count = 0;)

typedef struct token    t_token;
typedef struct position t_position;
typedef struct position sparse__pos;
typedef struct token    sparse__tok;
typedef struct position *sparsepos_t;
typedef struct token    *sparsetok_t;
typedef struct position *sparsepos_ptr;
typedef struct token    *sparsetok_ptr;

#define SvSPARSE(s,type)  ((type) SvIV((SV*) SvRV(s)))
#define SvSPARSE_POS(s)       SvSPARSE(s,sparsepos)
#define SvSPARSE_TOK(s)       SvSPARSE(s,sparsetok)

#define SPARSE_ASSUME(x,sv,type)			\
  do {							\
    assert (sv_derived_from (sv, type##_class));	\
    x = SvSPARSE(sv,type);                              \
  } while (0)

#define SPARSE_POS_ASSUME(x,sv)    SPARSE_ASSUME(x,sv,sparse_pos)
#define SPARSE_TOK_ASSUME(x,sv)    SPARSE_ASSUME(x,sv,sparse_tok)

#define SPARSE_MALLOC_ID  42

#define CREATE_SPARSE(type)				\
                                                        \
  struct type##_elem {                                  \
    type##_t            m;                              \
    struct type##_elem  *next;                          \
  };                                                    \
  typedef struct type##_elem  *type;                    \
  typedef struct type##_elem  *type##_assume;           \
  typedef type##_ptr          type##_coerce;            \
                                                        \
  static type type##_freelist = NULL;                   \
                                                        \
  static type                                           \
  new_##type (type##_t e)				\
  {                                                     \
    type p;                                             \
    TRACE (printf ("new %s(%p)\n", type##_class, e));          \
    if (type##_freelist != NULL)                        \
      {                                                 \
        p = type##_freelist;                            \
        type##_freelist = type##_freelist->next;        \
      }                                                 \
    else                                                \
      {                                                 \
        New (GMP_MALLOC_ID, p, 1, struct type##_elem);  \
        p->m = e;					\
      }                                                 \
    TRACE (printf ("  p=%p\n", p));                     \
    assert_support (type##_count++);                    \
    TRACE_ACTIVE ();                                    \
    return p;                                           \
  }                                                     \
  static SV *                                           \
  newbless_##type (type##_t e)				\
  {							\
    if (!e) return &PL_sv_undef;		        \
    return sv_bless (sv_setref_pv (sv_newmortal(), NULL, new_##type (e)), type##_class_hv); \
  } \
  static SV *newsv_##type (type##_t e)				\
  {							\
    if (!e) return &PL_sv_undef;		        \
    return sv_setref_pv (sv_newmortal(), NULL, new_##type (e)); \
  } \


CREATE_SPARSE(sparsepos);
CREATE_SPARSE(sparsetok);

static char *token_types_class[] =  {
	"sparse::tok::TOKEN_EOF",
	"sparse::tok::TOKEN_ERROR",
	"sparse::tok::TOKEN_IDENT",
	"sparse::tok::TOKEN_ZERO_IDENT",
	"sparse::tok::TOKEN_NUMBER",
	"sparse::tok::TOKEN_CHAR",
	"sparse::tok::TOKEN_CHAR_EMBEDDED_0",
	"sparse::tok::TOKEN_CHAR_EMBEDDED_1",
	"sparse::tok::TOKEN_CHAR_EMBEDDED_2",
	"sparse::tok::TOKEN_CHAR_EMBEDDED_3",
	"sparse::tok::TOKEN_WIDE_CHAR",
	"sparse::tok::TOKEN_WIDE_CHAR_EMBEDDED_0",
	"sparse::tok::TOKEN_WIDE_CHAR_EMBEDDED_1",
	"sparse::tok::TOKEN_WIDE_CHAR_EMBEDDED_2",
	"sparse::tok::TOKEN_WIDE_CHAR_EMBEDDED_3",
	"sparse::tok::TOKEN_STRING",
	"sparse::tok::TOKEN_WIDE_STRING",
	"sparse::tok::TOKEN_SPECIAL",
	"sparse::tok::TOKEN_STREAMBEGIN",
	"sparse::tok::TOKEN_STREAMEND",
	"sparse::tok::TOKEN_MACRO_ARGUMENT",
	"sparse::tok::TOKEN_STR_ARGUMENT",
	"sparse::tok::TOKEN_QUOTED_ARGUMENT",
	"sparse::tok::TOKEN_CONCAT",
	"sparse::tok::TOKEN_GNU_KLUDGE",
	"sparse::tok::TOKEN_UNTAINT",
	"sparse::tok::TOKEN_ARG_COUNT",
	"sparse::tok::TOKEN_IF",
	"sparse::tok::TOKEN_SKIP_GROUPS",
	"sparse::tok::TOKEN_ELSE",
	0
};
static SV *bless_tok(sparsetok_t e) {
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparsetok (e), gv_stashpv (token_types_class[token_type(e)],1));
}

static void
class_or_croak (SV *sv, const char *cl)
{
  if (! sv_derived_from (sv, cl))
    croak("not type %s", cl);
}

static void clean_up_symbols(struct symbol_list *list)
{
	struct symbol *sym;

	FOR_EACH_PTR(list, sym) {
		expand_symbol(sym);
	} END_FOR_EACH_PTR(sym);
}

int
sparse_main(int argc, char **argv)
{
	struct symbol_list * list;
	struct string_list *filelist = NULL; int i;
	char *file; struct symbol_list *all_syms = 0;
	
	list = sparse_initialize(argc, argv, &filelist);
	clean_up_symbols(list);

	FOR_EACH_PTR_NOTAG(filelist, file) {
	        printf("Sparse %s\n",file);
		struct symbol_list *syms = sparse(file);
		clean_up_symbols(syms);
		concat_symbol_list(syms, &all_syms);
	} END_FOR_EACH_PTR_NOTAG(file);
}


MODULE = sparse         PACKAGE = sparse

INCLUDE: const-xs.inc

BOOT:
    TRACE (printf ("sparse boot\n"));
    sparsepos_class_hv = gv_stashpv (sparsepos_class, 1);
    sparsetok_class_hv = gv_stashpv (sparsetok_class, 1);

INCLUDE_COMMAND: perl constdef.pl

void
END()
CODE:
    TRACE (printf ("sparse end\n"));

MODULE = sparse		PACKAGE = sparse		

SV *
hello()
    PREINIT:
        char *av[3] = {"prog", "test.c", 0};
    CODE:
        printf("Call sparse_main\n");
        sparse_main(2,av);
	RETVAL = newSV(0);
    OUTPUT:
	RETVAL

sparsepos
x2()
    PREINIT:
        char *av[3] = {"prog", "test.c", 0};
    CODE:
    OUTPUT:
	RETVAL



void
preprocess(...)
    PREINIT:
	struct string_list *filelist = NULL;
	char *file; char **a = 0; int i;
    PPCODE:
        a = (char **)malloc(sizeof(void *) * (items+2));
	a[0] = "sparse";
        for (i = 0; i < items; i++) {
            a[i+1] = SvPV_nolen(ST(i));
	}
        a[items+1] = 0;
	preprocess_only = 1;
	sparse_initialize(items+1, a, &filelist);
	FOR_EACH_PTR_NOTAG(filelist, file) {
		sparse(file);
		EXTEND(SP, 1);
		/*printf("pp_tokenlist:%p\n",pp_tokenlist);*/
		PUSHs(bless_tok (pp_tokenlist)); pp_tokenlist = 0;
	} END_FOR_EACH_PTR_NOTAG(file);
	free(a);


MODULE = sparse   PACKAGE = sparse::tok
PROTOTYPES: ENABLE

void
list(p,...)
	sparsetok p
    PREINIT:
	struct token *t; int cnt = 0;
    PPCODE:
	t = p->m;
	while(!eof_token(t)) {
	        cnt++;
 	    	if (GIMME_V == G_ARRAY) {
		   EXTEND(SP, 1);
		   PUSHs(bless_tok (t));
 		}
		t = t->next;
	}
 	if (GIMME_V == G_SCALAR) {
 	    EXTEND(SP, 1);
            PUSHs(sv_2mortal(newSViv(cnt)));
	}

INCLUDE_COMMAND: perl sparse.pl sparse.xsh
