#ifndef SCOPE_H
#define SCOPE_H
/*
 * Symbol scoping is pretty simple.
 *
 * Copyright (C) 2003 Transmeta Corp.
 *               2003 Linus Torvalds
 *
 *  Licensed under the Open Software License version 1.1
 */

struct symbol;

struct scope {
	struct token *token;		/* Scope start information */
	struct symbol_list *symbols;	/* List of symbols in this scope */
	struct scope *next;
};

extern struct scope
		*block_scope,
		*function_scope,
		*file_scope,
		*global_scope;

static inline int toplevel(SCTX_ struct scope *scope)
{
	return scope == file_scope || scope == global_scope;
}

extern void start_file_scope(SCTX);
extern void end_file_scope(SCTX);
extern void new_file_scope(SCTX);

extern void start_symbol_scope(SCTX);
extern void end_symbol_scope(SCTX);

extern void start_function_scope(SCTX);
extern void end_function_scope(SCTX);

extern void bind_scope(SCTX_ struct symbol *, struct scope *);

extern int is_outer_scope(SCTX_ struct scope *);
#endif
