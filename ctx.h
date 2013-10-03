#ifndef CTX_SPARSE_H
#define CTX_SPARSE_H

struct sparse_ctx {
	int a;
};

#define SCTX_ struct sparse_ctx *_sctx, 
#define SCTX  struct sparse_ctx *_sctx

#define sctx_ _sctx,
#define sctx  _sctx

#define SCTXCNT 1
#define DO_CTX

#define SPARSE_CTX_INIT struct sparse_ctx __sctx; struct sparse_ctx *_sctx = &__sctx;

#endif
