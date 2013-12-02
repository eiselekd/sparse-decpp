#!/usr/bin/perl -w
use C::sparse qw(:all);
use Test::More tests => 2;

ok( 1 );

$s0 = C::sparse::sparse("t/test_ptrs.c");
