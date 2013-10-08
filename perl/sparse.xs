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
#include "../parse.h"
#include "../expression.h"
#include "../symbol.h"
#include "../scope.h"

/* include the complete sparse tree */
#define D_USE_ONE
#include "../parse.c"

#include "const-c.inc"

#define TRACE(x) x
#define TRACE_ACTIVE()
#ifdef NDEBUG
#define assert_support(x)
#else
#define assert_support(x) x
#endif

static const char sparsectx_class[]  = "C::sparse::ctx";
static const char sparsepos_class[]  = "C::sparse::pos";
static const char sparsetok_class[]  = "C::sparse::tok";
static const char sparsestmt_class[]  = "C::sparse::stmt";
static const char sparsesym_class[]  = "C::sparse::sym";
static const char sparseexpr_class[]  = "C::sparse::expr";
static const char sparseident_class[]  = "C::sparse::ident";
static const char sparsectype_class[]  = "C::sparse::ctype";
static const char sparsesymctx_class[]  = "C::sparse::symctx";
static const char sparsescope_class[]  = "C::sparse::scope";
static const char sparseexpand_class[]  = "C::sparse::expand";
static HV *sparsectx_class_hv;
static HV *sparsepos_class_hv;
static HV *sparsetok_class_hv;
static HV *sparsestmt_class_hv;
static HV *sparseexpr_class_hv;
static HV *sparsesym_class_hv;
static HV *sparseident_class_hv;
static HV *sparsectype_class_hv;
static HV *sparsesymctx_class_hv;
static HV *sparsescope_class_hv;
static HV *sparseexpand_class_hv;
static HV *sparsestash;

assert_support (static long sparsectx_count = 0;)
assert_support (static long sparsepos_count = 0;)
assert_support (static long sparsetok_count = 0;)
assert_support (static long sparsestmt_count = 0;)
assert_support (static long sparsesym_count = 0;)
assert_support (static long sparseexpr_count = 0;)
assert_support (static long sparseident_count = 0;)
assert_support (static long sparsectype_count = 0;)
assert_support (static long sparsesymctx_count = 0;)
assert_support (static long sparsescope_count = 0;)
assert_support (static long sparseexpand_count = 0;)

typedef struct token     t_token;
typedef struct position  t_position;
typedef struct position  sparse__pos;
typedef struct token     sparse__tok;
typedef struct position  *sparsepos_t;
typedef struct token     *sparsetok_t;
typedef struct statement *sparsestmt_t;
typedef struct expression *sparseexpr_t;
typedef struct symbol    *sparsesym_t;
typedef struct ident     *sparseident_t;
typedef struct sym_context*sparsesymctx_t;
typedef struct ctype      *sparsectype_t;
typedef struct scope      *sparsescope_t;
typedef struct expansion  *sparseexpand_t;
typedef struct starse_ctx *sparsectx_t;
typedef struct position  *sparsepos_ptr;
typedef struct token     *sparsetok_ptr;
typedef struct statement *sparsestmt_ptr;
typedef struct expression *sparseexpr_ptr;
typedef struct symbol     *sparsesym_ptr;
typedef struct ident      *sparseident_ptr;
typedef struct sym_context*sparsesymctx_ptr;
typedef struct ctype      *sparsectype_ptr;
typedef struct scope      *sparsescope_ptr;
typedef struct expansion  *sparseexpand_ptr;
typedef struct sparse_ctx *sparsectx_ptr;

#define SvSPARSE(s,type)  ((type) (long)SvIV((SV*) SvRV(s)))
#define SvSPARSE_CTX(s)       SvSPARSE(s,sparsectx)
#define SvSPARSE_POS(s)       SvSPARSE(s,sparsepos)
#define SvSPARSE_TOK(s)       SvSPARSE(s,sparsetok)
#define SvSPARSE_STMT(s)      SvSPARSE(s,sparsestmt)
#define SvSPARSE_EXPR(s)      SvSPARSE(s,sparseexpr)
#define SvSPARSE_SYM(s)       SvSPARSE(s,sparsesym)
#define SvSPARSE_IDENT(s)     SvSPARSE(s,sparseident)
#define SvSPARSE_CTYPE(s)     SvSPARSE(s,sparsectype)
#define SvSPARSE_SYMCTX(s)    SvSPARSE(s,sparsesymctx)
#define SvSPARSE_SCOPE(s)     SvSPARSE(s,sparsescope)
#define SvSPARSE_EXPAND(s)       SvSPARSE(s,sparseexpand)

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
    /*TRACE (printf ("new %s(%p)\n", type##_class, e));*/          \
    if (type##_freelist != NULL)                        \
      {                                                 \
        p = type##_freelist;                            \
        type##_freelist = type##_freelist->next;        \
      }                                                 \
    else                                                \
      {                                                 \
        New (SPARSE_MALLOC_ID, p, 1, struct type##_elem);  \
        p->m = e;					\
      }                                                 \
    /*TRACE (printf ("  p=%p\n", p));*/                     \
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
CREATE_SPARSE(sparsestmt);
CREATE_SPARSE(sparseexpr);
CREATE_SPARSE(sparsesym);
CREATE_SPARSE(sparseident);
CREATE_SPARSE(sparsectype);
CREATE_SPARSE(sparsesymctx);
CREATE_SPARSE(sparsescope);
CREATE_SPARSE(sparseexpand);
CREATE_SPARSE(sparsectx);

static char *token_types_class[] =  {
	"C::sparse::tok::TOKEN_EOF",
	"C::sparse::tok::TOKEN_ERROR",
	"C::sparse::tok::TOKEN_IDENT",
	"C::sparse::tok::TOKEN_ZERO_IDENT",
	"C::sparse::tok::TOKEN_NUMBER",
	"C::sparse::tok::TOKEN_CHAR",
	"C::sparse::tok::TOKEN_CHAR_EMBEDDED_0",
	"C::sparse::tok::TOKEN_CHAR_EMBEDDED_1",
	"C::sparse::tok::TOKEN_CHAR_EMBEDDED_2",
	"C::sparse::tok::TOKEN_CHAR_EMBEDDED_3",
	"C::sparse::tok::TOKEN_WIDE_CHAR",
	"C::sparse::tok::TOKEN_WIDE_CHAR_EMBEDDED_0",
	"C::sparse::tok::TOKEN_WIDE_CHAR_EMBEDDED_1",
	"C::sparse::tok::TOKEN_WIDE_CHAR_EMBEDDED_2",
	"C::sparse::tok::TOKEN_WIDE_CHAR_EMBEDDED_3",
	"C::sparse::tok::TOKEN_STRING",
	"C::sparse::tok::TOKEN_WIDE_STRING",
	"C::sparse::tok::TOKEN_SPECIAL",
	"C::sparse::tok::TOKEN_STREAMBEGIN",
	"C::sparse::tok::TOKEN_STREAMEND",
	"C::sparse::tok::TOKEN_MACRO_ARGUMENT",
	"C::sparse::tok::TOKEN_STR_ARGUMENT",
	"C::sparse::tok::TOKEN_QUOTED_ARGUMENT",
	"C::sparse::tok::TOKEN_CONCAT",
	"C::sparse::tok::TOKEN_GNU_KLUDGE",
	"C::sparse::tok::TOKEN_UNTAINT",
	"C::sparse::tok::TOKEN_ARG_COUNT",
	"C::sparse::tok::TOKEN_IF",
	"C::sparse::tok::TOKEN_SKIP_GROUPS",
	"C::sparse::tok::TOKEN_ELSE",
	0
};
static SV *bless_tok(sparsetok_t e) {
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparsetok (e), gv_stashpv (token_types_class[token_type(e)],1));
}
static char *stmt_types_class[] =  {
	"C::sparse::stmt::STMT_NONE",
	"C::sparse::stmt::STMT_DECLARATION",
	"C::sparse::stmt::STMT_EXPRESSION",
	"C::sparse::stmt::STMT_COMPOUND",
	"C::sparse::stmt::STMT_IF",
	"C::sparse::stmt::STMT_RETURN",
	"C::sparse::stmt::STMT_CASE",
	"C::sparse::stmt::STMT_SWITCH",
	"C::sparse::stmt::STMT_ITERATOR",
	"C::sparse::stmt::STMT_LABEL",
	"C::sparse::stmt::STMT_GOTO",
	"C::sparse::stmt::STMT_ASM",
	"C::sparse::stmt::STMT_CONTEXT",
	"C::sparse::stmt::STMT_RANGE"
};
static SV *bless_stmt(sparsestmt_t e) {
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparsestmt(e), gv_stashpv (stmt_types_class[e->type],1));
}
static SV *bless_sparsestmt(sparsestmt_t e) { return bless_stmt(e); }

static char *sym_types_class[] =  {
	"C::sparse::sym::SYM_UNINITIALIZED",
	"C::sparse::sym::SYM_PREPROCESSOR",
	"C::sparse::sym::SYM_BASETYPE",
	"C::sparse::sym::SYM_NODE",
	"C::sparse::sym::SYM_PTR",
	"C::sparse::sym::SYM_FN",
	"C::sparse::sym::SYM_ARRAY",
	"C::sparse::sym::SYM_STRUCT",
	"C::sparse::sym::SYM_UNION",
	"C::sparse::sym::SYM_ENUM",
	"C::sparse::sym::SYM_TYPEDEF",
	"C::sparse::sym::SYM_TYPEOF",
	"C::sparse::sym::SYM_MEMBER",
	"C::sparse::sym::SYM_BITFIELD",
	"C::sparse::sym::SYM_LABEL",
	"C::sparse::sym::SYM_RESTRICT",
	"C::sparse::sym::SYM_FOULED",
	"C::sparse::sym::SYM_KEYWORD",
	"C::sparse::sym::SYM_BAD",
};
static SV *bless_sym(sparsesym_t e)   { 
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparsesym(e), gv_stashpv (sym_types_class[e->type],1));
}
static SV *bless_sparsesym(sparsesym_t e)   { return bless_sym(e); }

static char *expr_types_class[] =  {
        "C::sparse::expr::EXPR_NONE",
	"C::sparse::expr::EXPR_VALUE",
	"C::sparse::expr::EXPR_STRING",
	"C::sparse::expr::EXPR_SYMBOL",
	"C::sparse::expr::EXPR_TYPE",
	"C::sparse::expr::EXPR_BINOP",
	"C::sparse::expr::EXPR_ASSIGNMENT",
	"C::sparse::expr::EXPR_LOGICAL",
	"C::sparse::expr::EXPR_DEREF",
	"C::sparse::expr::EXPR_PREOP",
	"C::sparse::expr::EXPR_POSTOP",
	"C::sparse::expr::EXPR_CAST",
	"C::sparse::expr::EXPR_FORCE_CAST",
	"C::sparse::expr::EXPR_IMPLIED_CAST",
	"C::sparse::expr::EXPR_SIZEOF",
	"C::sparse::expr::EXPR_ALIGNOF",
	"C::sparse::expr::EXPR_PTRSIZEOF",
	"C::sparse::expr::EXPR_CONDITIONAL",
	"C::sparse::expr::EXPR_SELECT",
	"C::sparse::expr::EXPR_STATEMENT",
	"C::sparse::expr::EXPR_CALL",
	"C::sparse::expr::EXPR_COMMA",
	"C::sparse::expr::EXPR_COMPARE",
	"C::sparse::expr::EXPR_LABEL",
	"C::sparse::expr::EXPR_INITIALIZER",
	"C::sparse::expr::EXPR_IDENTIFIER",
	"C::sparse::expr::EXPR_INDEX",
	"C::sparse::expr::EXPR_POS",
	"C::sparse::expr::EXPR_FVALUE",
	"C::sparse::expr::EXPR_SLICE",
	"C::sparse::expr::EXPR_OFFSETOF"
};
static SV *bless_expr(sparseexpr_t e) {
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparseexpr(e), gv_stashpv (expr_types_class[e->type],1));
}
static SV *bless_sparseexpr(sparseexpr_t e) { return bless_expr(e); }

static SV *bless_ctype(sparsectype_t e) {
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparsectype(e), gv_stashpv (sparsectype_class,1));
}
static SV *bless_sparsectype(sparsectype_t e) { return bless_ctype(e); }
static SV *bless_symctx(sparsesymctx_t e) {
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparsesymctx(e), gv_stashpv (sparsesymctx_class,1));
}
static SV *bless_sparsesymctx(sparsesymctx_t e) { return bless_symctx(e); }
static SV *bless_scope(sparsescope_t e) {
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparsescope(e), gv_stashpv (sparsescope_class,1));
}
static SV *bless_sparsescope(sparsesymctx_t e) { return bless_symctx(e); }

static char *expand_types_class[] =  {
	"C::sparse::expand::EXPANSION_CMDLINE",
	"C::sparse::expand::EXPANSION_STREAM",
	"C::sparse::expand::EXPANSION_MACRO",
	"C::sparse::expand::EXPANSION_MACROARG",
	"C::sparse::expand::EXPANSION_CONCAT",
	"C::sparse::expand::EXPANSION_PREPRO",
};
static SV *bless_expand(sparseexpand_t e) {
    if (!e) return &PL_sv_undef;
    return sv_bless (newsv_sparseexpand(e), gv_stashpv (expand_types_class[e->typ],1));
}
static SV *bless_sparseexpand(sparseexpand_t e) { return bless_expand(e); }


static void
class_or_croak (SV *sv, const char *cl)
{
  if (! sv_derived_from (sv, cl))
    croak("not type %s", cl);
}

static void clean_up_symbols(SCTX_ struct symbol_list *list)
{
	struct symbol *sym;

	FOR_EACH_PTR(list, sym) {
		expand_symbol(sctx_ sym);
	} END_FOR_EACH_PTR(sym);
}

int
sparse_main(SCTX_ int argc, char **argv)
{
	struct symbol_list * list;
	struct string_list *filelist = NULL; int i;
	char *file; struct symbol_list *all_syms = 0;
	
	list = sparse_initialize(sctx_ argc, argv, &filelist);
	clean_up_symbols(sctx_ list);

	FOR_EACH_PTR_NOTAG(filelist, file) {
	        printf("Sparse %s\n",file);
		struct symbol_list *syms = sparse(sctx_ file);
		clean_up_symbols(sctx_ syms);
		concat_symbol_list(sctx_ syms, &all_syms);
	} END_FOR_EACH_PTR_NOTAG(file);
}


MODULE = C::sparse         PACKAGE = C::sparse

INCLUDE: const-xs.inc

BOOT:
    TRACE (printf ("sparse boot\n"));
    sparsectx_class_hv = gv_stashpv (sparsectx_class, 1);
    sparsepos_class_hv  = gv_stashpv (sparsepos_class, 1);
    sparsetok_class_hv  = gv_stashpv (sparsetok_class, 1);
    sparsestmt_class_hv = gv_stashpv (sparsestmt_class, 1);
    sparsesym_class_hv = gv_stashpv (sparsesym_class, 1);
    sparseexpr_class_hv = gv_stashpv (sparseexpr_class, 1);
    sparseident_class_hv = gv_stashpv (sparseident_class, 1);
    sparsectype_class_hv = gv_stashpv (sparsectype_class, 1);
    sparsesymctx_class_hv = gv_stashpv (sparsesymctx_class, 1);
    sparsescope_class_hv = gv_stashpv (sparsescope_class, 1);
    sparseexpand_class_hv = gv_stashpv (sparseexpand_class, 1);

INCLUDE_COMMAND: perl scripts/constdef.pl

void
END()
CODE:
    TRACE (printf ("sparse end\n"));

MODULE = C::sparse		PACKAGE = C::sparse		

SV *
hello()
    PREINIT:
        char *av[3] = {"prog", "test.c", 0};
    CODE:
        printf("Call sparse_main\n");
	SPARSE_CTX_INIT;
        sparse_main(sctx_ 2,av);
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


sparsectx
sparse(...)
    PREINIT:
	struct string_list *filelist = NULL;
	char *file; char **a = 0; int i; struct symbol *sym; struct symbol_list *symlist;
	struct sparse_ctx *_sctx;
    CODE:
        a = (char **)malloc(sizeof(void *) * (items+2));
	a[0] = "sparse";
        for (i = 0; i < items; i++) {
            a[i+1] = SvPV_nolen(ST(i));
	}
        a[items+1] = 0;
	TRACE(printf("sparse_initialize("));
	for (i = 0; i < items+1; i++) {
	    TRACE(printf(" \"%s\"",a[i]));
        }
	TRACE(printf(")\n"));
	New (SPARSE_MALLOC_ID,  _sctx, 1, struct sparse_ctx);
	_sctx = sparse_ctx_init( _sctx);
	_sctx ->symlist = sparse_initialize(sctx_ items+1, a, &_sctx->filelist);
	RETVAL = new_sparsectx((sparsectx_t)sctx);
    OUTPUT:
	RETVAL	

#	FOR_EACH_PTR(symlist, sym) {
#	    EXTEND(SP, 1);
#	    PUSHs(bless_sym (sym));
#	} END_FOR_EACH_PTR(sym);
#	FOR_EACH_PTR_NOTAG(filelist, file) {
#	    symlist = sparse(file);
#	    FOR_EACH_PTR(symlist, sym) {
#	        EXTEND(SP, 1);
#		PUSHs(bless_sym (sym));
#	    } END_FOR_EACH_PTR(sym);
#	} END_FOR_EACH_PTR_NOTAG(file);
#	free(a);

MODULE = C::sparse   PACKAGE = C::sparse::tok
PROTOTYPES: ENABLE

void
list(p,...)
	sparsetok p
    PREINIT:
    struct token *t; int cnt = 0; SPARSE_CTX_GEN(0);
    PPCODE:
        SPARSE_CTX_SET(t->ctx)
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

MODULE = C::sparse   PACKAGE = C::sparse::ident
PROTOTYPES: ENABLE

SV *
name(i)
	sparseident i
    PREINIT:
        int len = 0;
    CODE:
        RETVAL = newSVpv(i->m->name,i->m->len);
    OUTPUT:
	RETVAL

MODULE = C::sparse   PACKAGE = C::sparse::sym
PROTOTYPES: ENABLE

SV *
name(s)
	sparsesym s
    PREINIT:
        int len = 0; struct ident *i; const char *n;
    CODE:
	if (!s->m || !(i = s->m->ident))
	   XSRETURN_UNDEF;
	n = show_ident(s->m->ctx, i);
        RETVAL = newSVpv(n,0);
    OUTPUT:
	RETVAL

MODULE = C::sparse   PACKAGE = C::sparse::ctype
PROTOTYPES: ENABLE

SV *
name(s)
	sparsectype s
    PREINIT:
        int len = 0; const char *n; struct symbol *sym;
    CODE:
	if (!s->m || ! (sym = s->m->base_type))
	   XSRETURN_UNDEF;
	n = builtin_typename(sym->ctx,sym) ?: show_ident(sym->ctx,sym->ident);
        RETVAL = newSVpv(n,0);
    OUTPUT:
	RETVAL

SV *
typename(s)
	sparsectype s
    PREINIT:
        int len = 0; const char *n; struct symbol *sym;
    CODE:
	if (!s->m || ! (sym = s->m->base_type))
	   XSRETURN_UNDEF;
	n = show_typename_fn(sym->ctx,sym);
        RETVAL = newSVpv(n,0);
	if (n)
	    free((char*)n);
    OUTPUT:
	RETVAL


INCLUDE_COMMAND: perl scripts/sparse.pl sparse.xsh
