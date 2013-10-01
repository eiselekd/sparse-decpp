use Data::Dumper;
use Getopt::Long;
use Getopt::Long;
use Carp;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Cwd;
use Cwd 'abs_path';

foreach my $v (qw(
        EXPR_NONE
	EXPR_VALUE
	EXPR_STRING
	EXPR_SYMBOL
	EXPR_TYPE
	EXPR_BINOP
	EXPR_ASSIGNMENT
	EXPR_LOGICAL
	EXPR_DEREF
	EXPR_PREOP
	EXPR_POSTOP
	EXPR_CAST
	EXPR_FORCE_CAST
	EXPR_IMPLIED_CAST
	EXPR_SIZEOF
	EXPR_ALIGNOF
	EXPR_PTRSIZEOF
	EXPR_CONDITIONAL
	EXPR_SELECT
	EXPR_STATEMENT
	EXPR_CALL
	EXPR_COMMA
	EXPR_COMPARE
	EXPR_LABEL
	EXPR_INITIALIZER
	EXPR_IDENTIFIER
	EXPR_INDEX
	EXPR_POS
	EXPR_FVALUE
	EXPR_SLICE
	EXPR_OFFSETOF


    )) {
     print("package sparse::sym::$v;\n");
     print("our \@ISA = qw (sparse::sym);\n");

   }


