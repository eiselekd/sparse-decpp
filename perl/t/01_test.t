#!/usr/bin/perl -w
use C::sparse qw(:all);
use C::sparse::sym;
use Test::More tests => 2;

ok( 1 );

$s0 = C::sparse::sparse("t/test_ptrs.c");

my @s = $s0->symbols();
print ("Number of symbols:".scalar(@s)."\n");
foreach my $s (@s) {
  print("symbol: ".$s.":".$C::sparse::sym::typ_n{$s->type}."\n");
  print(" ".$s->symbol_list);
  print("\n");
}

#print ("SYM_PTR:".C::sparse::SYM_PTR);