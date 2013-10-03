use POSIX;
use sparse qw(:all);
#use Devel::Peek;

%SYM_typ = (
	sparse::SYM_UNINITIALIZED=>"SYM_UNINITIALIZED" ,
	sparse::SYM_PREPROCESSOR =>"SYM_PREPROCESSOR"  ,
	sparse::SYM_BASETYPE     =>"SYM_BASETYPE"      ,
	sparse::SYM_NODE         =>"SYM_NODE"          ,
	sparse::SYM_PTR          =>"SYM_PTR"           ,
	sparse::SYM_FN           =>"SYM_FN"            ,
	sparse::SYM_ARRAY        =>"SYM_ARRAY"         ,
	sparse::SYM_STRUCT       =>"SYM_STRUCT"        ,
	sparse::SYM_UNION        =>"SYM_UNION"         ,
	sparse::SYM_ENUM         =>"SYM_ENUM"          ,
	sparse::SYM_TYPEDEF      =>"SYM_TYPEDEF"       ,
	sparse::SYM_TYPEOF       =>"SYM_TYPEOF"        ,
	sparse::SYM_MEMBER       =>"SYM_MEMBER"        ,
	sparse::SYM_BITFIELD     =>"SYM_BITFIELD"      ,
	sparse::SYM_LABEL        =>"SYM_LABEL"         ,
	sparse::SYM_RESTRICT     =>"SYM_RESTRICT"      ,
	sparse::SYM_FOULED       =>"SYM_FOULED"        ,
	sparse::SYM_KEYWORD      =>"SYM_KEYWORD"       ,
	sparse::SYM_BAD          =>"SYM_BAD"           
);


$s = sparse::sparse("../lib.c");

#foreach my $a (@a) {
#  if ($a->namespace != sparse::NS_PREPROCESSOR) {
#    my $cnt = $a->arguments;
#    my $symbt = $a->ctype->base_type;
#    
#    print "name         : ".$a->name."=".$a->ctype->typename."\n";
#    print "bttype       : ".$SYM_typ{$symbt->type}.":".sprintf("0x%x",$a->ctype->modifiers)."\n";
#  }
#}

#$p = 
#print($p->pos);

