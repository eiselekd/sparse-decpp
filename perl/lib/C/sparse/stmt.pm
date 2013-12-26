package C::sparse::stmt;

our %typ_n = (
	C::sparse::STMT_NONE        => "STMT_NONE",	      
	C::sparse::STMT_DECLARATION => "STMT_DECLARATION",  
	C::sparse::STMT_EXPRESSION  => "STMT_EXPRESSION",   
	C::sparse::STMT_COMPOUND    => "STMT_COMPOUND",     
	C::sparse::STMT_IF	    => "STMT_IF",	      
	C::sparse::STMT_RETURN	    => "STMT_RETURN",	      
	C::sparse::STMT_CASE	    => "STMT_CASE",	      
	C::sparse::STMT_SWITCH	    => "STMT_SWITCH",	      
	C::sparse::STMT_ITERATOR    => "STMT_ITERATOR",     
	C::sparse::STMT_LABEL	    => "STMT_LABEL",	      
	C::sparse::STMT_GOTO	    => "STMT_GOTO",	      
	C::sparse::STMT_ASM	    => "STMT_ASM",	      
	C::sparse::STMT_CONTEXT     => "STMT_CONTEXT",      
	C::sparse::STMT_RANGE       => "STMT_RANGE"          
);

package C::sparse::stmt::STMT_NONE;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_DECLARATION;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_EXPRESSION;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_COMPOUND;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_IF;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_RETURN;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_CASE;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_SWITCH;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_ITERATOR;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_LABEL;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_GOTO;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_ASM;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_CONTEXT;
our @ISA = qw (C::sparse::stmt);
package C::sparse::stmt::STMT_RANGE;
our @ISA = qw (C::sparse::stmt);

1;
