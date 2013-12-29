#!/usr/bin/perl -w
use Data::Dump;
use C::sparse qw(:all);
use Test::More tests => 2;

#pp(\%INC);

$s0 = C::sparse::sparse("t/test_ptrs.c");

my @typedefs = $s0->symbols($typ = (C::sparse::NS_STRUCT));
my $idx = 0;
print("typ: $typ\n");
foreach my $t (@typedefs) {
  my $struct = $t->totype;
  print ($idx.":".$struct->n.":".$struct."\n");
  $idx++;
}

my @s = $s0->symbols();
print ("Number of symbols:".scalar(@s)."\n");
foreach my $s (@s) {
  print("symbol: ".$s.":".$C::sparse::sym::typ_n{$s->type}."\n");
  #print(" ".$s->symbol_list);
  my $fn = $s->totype;
  print ("Fn: ".$fn.":isa:".$fn->isa('C::sparse::type::fn')."\n");
  if ($fn->isa('C::sparse::type::fn')) {
    print ("Function:".$fn->n."\n");
    my $idx = 0;
    foreach my $a ($fn->args) {
      print (" $idx:".$a->n.":".$a."\n"); $idx++;
    }
    
    foreach my $c ($fn->c) {
      print (" c:".$c."\n");
    }
    foreach my $l ($fn->l) {
      my @p = $l->p;
      print (' ' x scalar(@p));
      print (" l:".$l."\n");
    }
  }
  print("\n");
}

#print ("SYM_PTR:".C::sparse::SYM_PTR);
