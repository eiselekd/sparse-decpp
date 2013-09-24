use POSIX;
use sparse;
use Devel::Peek;

@a = sparse::preprocess("test.c");

foreach my $a (@a) {
  foreach my $l ($a->list) {
    print ($l->pos->pos.":".$l->pos->line."\n");
  }
}

#$p = 
#print($p->pos);





