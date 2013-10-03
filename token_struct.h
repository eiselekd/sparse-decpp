#ifndef TOKEN_STRUCT_H
#define TOKEN_STRUCT_H
/*
 * Basic tokenization structures. NOTE! Those tokens had better
 * be pretty small, since we're going to keep them all in memory
 * indefinitely.
 *
 * Copyright (C) 2003 Transmeta Corp.
 *               2003 Linus Torvalds
 *
 *  Licensed under the Open Software License version 1.1
 */

#include <sys/types.h>
#include "lib.h"

/*
 * This describes the pure lexical elements (tokens), with
 * no semantic meaning. In other words, an identifier doesn't
 * have a type or meaning, it is only a specific string in
 * the input stream.
 *
 * Semantic meaning is handled elsewhere.
 */

enum constantfile {
  CONSTANT_FILE_MAYBE,    // To be determined, not inside any #ifs in this file
  CONSTANT_FILE_IFNDEF,   // To be determined, currently inside #ifndef
  CONSTANT_FILE_NOPE,     // No
  CONSTANT_FILE_YES       // Yes
};

extern const char *includepath[];

struct stream {
	int fd;
	const char *name;
	const char *path;    // input-file path - see set_stream_include_path()
	const char **next_path;

	/* Use these to check for "already parsed" */
	enum constantfile constant;
	int dirty, next_stream, once;
	struct ident *protect;
	struct token *ifndef;
	struct token *top_if;
};

#ifndef DO_CTX
extern int input_stream_nr;
extern struct stream *input_streams;
extern unsigned int tabstop;
#endif
extern int *hash_stream(SCTX_ const char *name);

struct ident {
	struct ident *next;	/* Hash chain of identifiers */
	struct symbol *symbols;	/* Pointer to semantic meaning list */
	unsigned char len;	/* Length of identifier name */
	unsigned char tainted:1,
	              reserved:1,
		      keyword:1;
	char name[];		/* Actual identifier */
};

enum token_type {
	TOKEN_EOF,
	TOKEN_ERROR,
	TOKEN_IDENT,
	TOKEN_ZERO_IDENT,
	TOKEN_NUMBER,
	TOKEN_CHAR,
	TOKEN_CHAR_EMBEDDED_0,
	TOKEN_CHAR_EMBEDDED_1,
	TOKEN_CHAR_EMBEDDED_2,
	TOKEN_CHAR_EMBEDDED_3,
	TOKEN_WIDE_CHAR,
	TOKEN_WIDE_CHAR_EMBEDDED_0,
	TOKEN_WIDE_CHAR_EMBEDDED_1,
	TOKEN_WIDE_CHAR_EMBEDDED_2,
	TOKEN_WIDE_CHAR_EMBEDDED_3,
	TOKEN_STRING,
	TOKEN_WIDE_STRING,
	TOKEN_SPECIAL,
	TOKEN_STREAMBEGIN,
	TOKEN_STREAMEND,
	TOKEN_MACRO_ARGUMENT,
	TOKEN_STR_ARGUMENT,
	TOKEN_QUOTED_ARGUMENT,
	TOKEN_CONCAT,
	TOKEN_GNU_KLUDGE,
	TOKEN_UNTAINT,
	TOKEN_ARG_COUNT,
	TOKEN_IF,
	TOKEN_SKIP_GROUPS,
	TOKEN_ELSE,
};

/* Combination tokens */
#define COMBINATION_STRINGS {	\
	"+=", "++",		\
	"-=", "--", "->",	\
	"*=",			\
	"/=",			\
	"%=",			\
	"<=", ">=",		\
	"==", "!=",		\
	"&&", "&=",		\
	"||", "|=",		\
	"^=", "##",		\
	"<<", ">>", "..",	\
	"<<=", ">>=", "...",	\
	"",			\
	"<", ">", "<=", ">="	\
}

extern unsigned char combinations[][4];

enum special_token {
	SPECIAL_BASE = 256,
	SPECIAL_ADD_ASSIGN = SPECIAL_BASE,
	SPECIAL_INCREMENT,
	SPECIAL_SUB_ASSIGN,
	SPECIAL_DECREMENT,
	SPECIAL_DEREFERENCE,
	SPECIAL_MUL_ASSIGN,
	SPECIAL_DIV_ASSIGN,
	SPECIAL_MOD_ASSIGN,
	SPECIAL_LTE,
	SPECIAL_GTE,
	SPECIAL_EQUAL,
	SPECIAL_NOTEQUAL,
	SPECIAL_LOGICAL_AND,
	SPECIAL_AND_ASSIGN,
	SPECIAL_LOGICAL_OR,
	SPECIAL_OR_ASSIGN,
	SPECIAL_XOR_ASSIGN,
	SPECIAL_HASHHASH,
	SPECIAL_LEFTSHIFT,
	SPECIAL_RIGHTSHIFT,
	SPECIAL_DOTDOT,
	SPECIAL_SHL_ASSIGN,
	SPECIAL_SHR_ASSIGN,
	SPECIAL_ELLIPSIS,
	SPECIAL_ARG_SEPARATOR,
	SPECIAL_UNSIGNED_LT,
	SPECIAL_UNSIGNED_GT,
	SPECIAL_UNSIGNED_LTE,
	SPECIAL_UNSIGNED_GTE,
};

struct string {
	unsigned int length;
	char data[];
};

/* will fit into 32 bits */
struct argcount {
	unsigned normal:10;
	unsigned quoted:10;
	unsigned str:10;
	unsigned vararg:1;
};

/*
 * This is a very common data structure, it should be kept
 * as small as humanly possible. Big (rare) types go as
 * pointers.
 */
struct token {
#ifdef DO_CTX
	struct sparse_ctx *ctx;
#endif
	struct position pos;
	struct token *next;
	struct expansion *e;
	union {
		const char *number;
		struct ident *ident;
		unsigned int special;
		struct string *string;
		int argnum;
		struct argcount count;
		char embedded[4];
	};
};

enum expansion_typ {
	EXPANSION_CMDLINE,
	EXPANSION_STREAM,
	EXPANSION_MACRO,
	EXPANSION_MACROARG,
	EXPANSION_CONCAT,
	EXPANSION_PREPRO
};

struct expansion {
	int typ;
	struct token *s, *d;
	union {
		struct { /* marg */
			struct expansion *mac;
		};
		struct { /* macro */
			struct symbol *msym;
			struct token *tok;
		};
	};
};


#endif
