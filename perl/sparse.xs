#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#define D_USE_ONE
#include "../parse.c"

typedef struct token    t_token;
typedef struct position t_position;
typedef struct position sparse__pos;
typedef struct token    sparse__tok;

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

INCLUDE_COMMAND: perl sparse.pl sparse.xsh
