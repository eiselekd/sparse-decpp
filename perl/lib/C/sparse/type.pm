package C::sparse::ctype; 
our @ISA = qw (C::sparse::type); 
use Carp;
use strict; 
use warnings;

my %m = (
    'C::sparse::sym::SYM_FN'       => 'C::sparse::type::fn',
    'C::sparse::sym::SYM_STRUCT'   => 'C::sparse::type::rec',
    'C::sparse::sym::SYM_UNION'    => 'C::sparse::type::rec',
    'C::sparse::sym::SYM_ENUM'     => 'C::sparse::type::rec',
    'C::sparse::sym::SYM_PTR'      => 'C::sparse::type::ptr',
    'C::sparse::sym::SYM_TYPEDEF'  => 'C::sparse::type::typedef',
    'C::sparse::sym::SYM_BASETYPE' => 'C::sparse::type::BASETYPE'
);

sub totype { my $s = shift; return C::sparse::type::totype($s->base_type, @_); }

sub l { return (); }
sub c { return (); }

package C::sparse::type; 
our @ISA = qw (C::sparse::sym); use Carp;

sub n {
  return "<undef>" if (!defined($_[0]->{'_n'}));
  return $_[0]->{'_n'}->name;
}

sub totype { 
  my $b = $_[0];
  return bless ({_o=>$b,_n=>$_[1]}, $m{ref($b)}) if (defined($m{ref($b)}));
  confess("\nCannot map :".ref($b).":"); 
} 

package C::sparse::type::fn; 
our @ISA = qw (C::sparse::ctype); use Carp;

sub args { return map { $_->totype } $_[0]->{'_o'}->arguments; }
sub l { return $_[0]->{'_o'}->stmt->l; }
sub c { return $_[0]->{'_o'}->stmt; }

package C::sparse::type::rec; 
our @ISA = qw (C::sparse::ctype); use Carp;

package C::sparse::type::typedef; 
our @ISA = qw (C::sparse::ctype); use Carp;

package C::sparse::type::ptr; 
our @ISA = qw (C::sparse::ctype); use Carp;

package C::sparse::type::BASETYPE; 
our @ISA = qw (C::sparse::ctype); use Carp;

1;
