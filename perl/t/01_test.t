#!/usr/bin/perl -w
use C::sparse qw(:all);
use Test::More tests => 2;

ok( 1 );

$s0 = C::sparse::sparse("t/test_ptrs.c");

my @s = $s0->symbols();
print ("Number of symbols:".scalar(@s)."\n");
foreach my $s (@s) {
  print("symbol: ".$s."\n");
  print(" ".$s->symbol_list);
  print("\n");
}
