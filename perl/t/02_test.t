#!/usr/bin/perl -w
use C::sparse qw(:all);
use Test::More tests => 2;

my $s0 = C::sparse::sparse("t/test_ptrs.c");

my @typedefs = $s0->symbols($typ = (C::sparse::NS_STRUCT));
my $idx = 0;
print("typ: $typ\n");
foreach my $t (@typedefs) {
  my $struct = $t->totype;
  print ($idx.":".$struct->n.":".$struct."\n");
  
  
  foreach my $l ($struct->l) {
      my @p = $l->p;
      print (' ' x scalar(@p));
      print (" l:".$l->n.":".$l.":".$l->typename."\n");
  }
  
  $idx++;
}



ok( 1 );
ok( 1 );



