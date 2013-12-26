package C::sparse::expr;

our %typ_n = (

	C::sparse::EXPR_VALUE=>          "EXPR_VALUE",	 
	C::sparse::EXPR_STRING=>	 "EXPR_STRING",	 
	C::sparse::EXPR_SYMBOL=>	 "EXPR_SYMBOL",	 
	C::sparse::EXPR_TYPE=>	         "EXPR_TYPE",	 
	C::sparse::EXPR_BINOP=>	         "EXPR_BINOP",	 
	C::sparse::EXPR_ASSIGNMENT=>     "EXPR_ASSIGNMENT", 
	C::sparse::EXPR_LOGICAL=>	 "EXPR_LOGICAL",	 
	C::sparse::EXPR_DEREF=>	         "EXPR_DEREF",	 
	C::sparse::EXPR_PREOP=>	         "EXPR_PREOP",	 
	C::sparse::EXPR_POSTOP=>	 "EXPR_POSTOP",	 
	C::sparse::EXPR_CAST=>	         "EXPR_CAST",	 
	C::sparse::EXPR_FORCE_CAST=>     "EXPR_FORCE_CAST", 
	C::sparse::EXPR_IMPLIED_CAST=>   "EXPR_IMPLIED_CAST",
	C::sparse::EXPR_SIZEOF=>	 "EXPR_SIZEOF",	 
	C::sparse::EXPR_ALIGNOF=>	 "EXPR_ALIGNOF",	 
	C::sparse::EXPR_PTRSIZEOF=>	 "EXPR_PTRSIZEOF",	 
	C::sparse::EXPR_CONDITIONAL=>    "EXPR_CONDITIONAL",
	C::sparse::EXPR_SELECT=>	 "EXPR_SELECT",	 	
	C::sparse::EXPR_STATEMENT=>	 "EXPR_STATEMENT",	 
	C::sparse::EXPR_CALL=>	         "EXPR_CALL",	 
	C::sparse::EXPR_COMMA=>	         "EXPR_COMMA",	 
	C::sparse::EXPR_COMPARE=>	 "EXPR_COMPARE",	 
	C::sparse::EXPR_LABEL=>	         "EXPR_LABEL",	 
	C::sparse::EXPR_INITIALIZER=>    "EXPR_INITIALIZER",	
	C::sparse::EXPR_IDENTIFIER=>     "EXPR_IDENTIFIER", 	
	C::sparse::EXPR_INDEX=>	         "EXPR_INDEX",	 	
	C::sparse::EXPR_POS=>	         "EXPR_POS",	 	
	C::sparse::EXPR_FVALUE=>	 "EXPR_FVALUE",	 
	C::sparse::EXPR_SLICE=>	         "EXPR_SLICE",	 
	C::sparse::EXPR_OFFSETOF=>       "EXPR_OFFSETOF"   
);

package C::sparse::expr::EXPR_NONE;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_VALUE;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_STRING;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_SYMBOL;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_TYPE;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_BINOP;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_ASSIGNMENT;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_LOGICAL;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_DEREF;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_PREOP;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_POSTOP;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_CAST;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_FORCE_CAST;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_IMPLIED_CAST;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_SIZEOF;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_ALIGNOF;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_PTRSIZEOF;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_CONDITIONAL;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_SELECT;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_STATEMENT;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_CALL;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_COMMA;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_COMPARE;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_LABEL;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_INITIALIZER;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_IDENTIFIER;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_INDEX;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_POS;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_FVALUE;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_SLICE;
our @ISA = qw (C::sparse::expr);
package C::sparse::expr::EXPR_OFFSETOF;
our @ISA = qw (C::sparse::expr);
1;

