#ifndef CTX_SPARSE_H
#define CTX_SPARSE_H

#include "ctx_def.h"
#include "lib.h"
#include "symbol_struct.h"
#include "allocate_struct.h"

/* lib.c */
#ifndef __GNUC__
# define __GNUC__ 2
# define __GNUC_MINOR__ 95
# define __GNUC_PATCHLEVEL__ 0
#endif
#define CMDLINE_INCLUDE 20
#ifdef __x86_64__
#define ARCH_M64_DEFAULT 1
#else
#define ARCH_M64_DEFAULT 0
#endif

struct warning {
	const char *name;
	int *flag;
};

/*parse.c*/
struct init_keyword {
	const char *name;
	enum namespace ns;
	unsigned long modifiers;
	struct symbol_op *op;
	struct symbol *type;
};

/*symbol.c*/
struct ctype_declare {
	struct symbol *ptr;
	enum type type;
	unsigned long modifiers;
	int *bit_size;
	int *maxalign;
	struct symbol *base_type;
};
/*show-parse.c*/
struct ctype_name {
	struct symbol *sym;
	const char *name;
};

struct sparse_ctx {
	/* dissect.c */
	struct reporter *reporter;
	/*static*/ struct symbol *return_type;
	
	/* liveness.c */
	/*static*/ int liveness_changed;

	/* storage.c */
#define MAX_STORAGE_HASH 64
	/*static*/ struct storage_hash_list *storage_hash_table[MAX_STORAGE_HASH];

	/* show-parse.c */
	struct ctype_name *typenames; /* todo: release */
	int typenames_cnt;

	/* parse.c */
	struct init_keyword *keyword_table; /* todo: release */
	int keyword_table_cnt;
	
        /* keep sync with parse.h */
	struct symbol * int_types[4];
	struct symbol * signed_types[5];
	struct symbol * unsigned_types[5];
	struct symbol * real_types[3];
	struct symbol * char_types[3];
	struct symbol ** types[7];


	/*static */struct symbol_list **function_symbol_list;
	struct symbol_list *function_computed_target_list;
	struct statement_list *function_computed_goto_list;
	/* lib.c */
	int verbose, optimize, optimize_size, preprocessing;
	int die_if_error/* = 0*/;
	int gcc_major /*= __GNUC__*/;
	int gcc_minor /*= __GNUC_MINOR__*/;
	int gcc_patchlevel /*= __GNUC_PATCHLEVEL__*/;
	struct token *pp_tokenlist /*= NULL*/;
	/*static*/ const char *gcc_base_dir /*= GCC_BASE*/;
	/*static*/ int max_warnings/* = 100*/;
	/*static*/ int show_info/* = 1*/;
	
	/*static*/ struct token *pre_buffer_begin/* = NULL*/;
	/*static*/ struct token *pre_buffer_end/* = NULL*/;

	int Waddress_space/* = 1*/;
	int Wbitwise /*= 0*/;
	int Wcast_to_as /*= 0*/;
	int Wcast_truncate /*= 1*/;
	int Wcontext /*= 1*/;
	int Wdecl /*= 1*/;
	int Wdeclarationafterstatement /*= -1*/;
	int Wdefault_bitfield_sign /*= 0*/;
	int Wdesignated_init /*= 1*/;
	int Wdo_while /*= 0*/;
	int Winit_cstring /*= 0*/;
	int Wenum_mismatch /*= 1*/;
	int Wnon_pointer_null /*= 1*/;
	int Wold_initializer /*= 1*/;
	int Wone_bit_signed_bitfield /*= 1*/;
	int Wparen_string /*= 0*/;
	int Wptr_subtraction_blows /*= 0*/;
	int Wreturn_void /*= 0*/;
	int Wshadow /*= 0*/;
	int Wtransparent_union /*= 0*/;
	int Wtypesign /*= 0*/;
	int Wundef /*= 0*/;
	int Wuninitialized /*= 1*/;
	int Wvla /*= 1*/;
	
	int dbg_entry /*= 0*/;
	int dbg_dead /*= 0*/;
	
	int preprocess_only;

	int arch_m64/* = ARCH_M64_DEFAULT*/;
	int arch_msize_long /*= 0*/;
	
	/*static*/ int cmdline_include_nr /*= 0*/;
	/*static*/ char *cmdline_include[CMDLINE_INCLUDE];
	
#define WCNT 24
	struct warning warnings[WCNT];
#define DCNT 2
	struct warning debugs[DCNT];

	/* target.c */
	struct symbol *size_t_ctype/* = &uint_ctype*/;
	struct symbol *ssize_t_ctype /*= &int_ctype*/;

	int max_alignment /*= 16*/;

	int bits_in_bool /*= 1*/;
	int bits_in_char /*= 8*/;
	int bits_in_short /*= 16*/;
	int bits_in_int /*= 32*/;
	int bits_in_long /*= 32*/;
	int bits_in_longlong /*= 64*/;
	int bits_in_longlonglong /*= 128*/;
	
	int max_int_alignment /*= 4*/;
	
	int bits_in_float /*= 32*/;
	int bits_in_double /*= 64*/;
	int bits_in_longdouble /*= 80*/;
	
	int max_fp_alignment /*= 8*/;
	
	int bits_in_pointer /*= 32*/;
	int pointer_alignment /*= 4*/;
	
	int bits_in_enum /*= 32*/;
	int enum_alignment /*= 4*/;

	/* symbol.c */
	struct symbol	int_type,
			fp_type;
	struct symbol	bool_ctype, void_ctype, type_ctype,
			char_ctype, schar_ctype, uchar_ctype,
			short_ctype, sshort_ctype, ushort_ctype,
			int_ctype, sint_ctype, uint_ctype,
			long_ctype, slong_ctype, ulong_ctype,
			llong_ctype, sllong_ctype, ullong_ctype,
			lllong_ctype, slllong_ctype, ulllong_ctype,
			float_ctype, double_ctype, ldouble_ctype,
			string_ctype, ptr_ctype, lazy_ptr_ctype,
			incomplete_ctype, label_ctype, bad_ctype,
			null_ctype;
	struct symbol	zero_int;

	/* linearize.c */
	ALLOCATOR_DEF(pseudo_user, "pseudo_user", 0);
	ALLOCATOR_DEF(asm_rules, "asm rules", 0);
	ALLOCATOR_DEF(asm_constraint, "asm constraints", 0);
  
	/* allocate.c */
	ALLOCATOR_DEF(ident, "identifiers",0);
	ALLOCATOR_DEF(token, "tokens",1);
	ALLOCATOR_DEF(expansion, "expansions",1);
	ALLOCATOR_DEF(sym_context, "sym_contexts",0);
	ALLOCATOR_DEF(symbol, "symbols",0);
	ALLOCATOR_DEF(expression, "expressions",0);
	ALLOCATOR_DEF(statement, "statements",0);
	ALLOCATOR_DEF(string, "strings",0);
	ALLOCATOR_DEF(scope, "scopes",0);
	ALLOCATOR_DEF(bytes, "bytes",0);
	ALLOCATOR_DEF(basic_block, "basic_block",0);
	ALLOCATOR_DEF(entrypoint, "entrypoint",0);
	ALLOCATOR_DEF(instruction, "instruction",0);
	ALLOCATOR_DEF(multijmp, "multijmp",0);
	ALLOCATOR_DEF(pseudo, "pseudo",0);

	/* ptrlist.c */
	ALLOCATOR_DEF(ptrlist, "ptr list",0);
	
	/* storage.c */
	ALLOCATOR_DEF(storage, "storages", 0);
	ALLOCATOR_DEF(storage_hash, "storage hash", 0);

	/* sparse-llvm.c */
	ALLOCATOR_DEF(llfunc, "llfuncs", 0);
	
	/* perl/sparse.xs */
	struct string_list *filelist;
	struct symbol_list *symlist;
	
};

extern void sparse_ctx_init_parse1(struct sparse_ctx *);
extern void sparse_ctx_init_parse2(struct sparse_ctx *);
extern void sparse_ctx_init_show_parse(struct sparse_ctx *);

#endif