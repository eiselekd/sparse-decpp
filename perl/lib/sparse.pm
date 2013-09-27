use ExtUtils::testlib;  
package sparse;

use 5.012003;
use strict;
use warnings;

#our @ISA = qw(Exporter);

our $AUTOLOAD;

our $VERSION = '0.01';

require XSLoader;

my $loaded;

sub import {
    my $pkg = shift;

    load_imports() unless $loaded++;

    # Grandfather old foo_h form to new :foo_h form
    s/^(?=\w+_h$)/:/ for my @list = @_;

    local $Exporter::ExportLevel = 1;
    Exporter::import($pkg,@list);
}

XSLoader::load('sparse', $VERSION);

sub load_imports {
    
    our %EXPORT_TAGS = ( 
	constants =>	
	[qw(
	TOKEN_EOF
	TOKEN_ERROR
	TOKEN_IDENT
	TOKEN_ZERO_IDENT
	TOKEN_NUMBER
	TOKEN_CHAR
	TOKEN_CHAR_EMBEDDED_0
	TOKEN_CHAR_EMBEDDED_1
	TOKEN_CHAR_EMBEDDED_2
	TOKEN_CHAR_EMBEDDED_3
	TOKEN_WIDE_CHAR
	TOKEN_WIDE_CHAR_EMBEDDED_0
	TOKEN_WIDE_CHAR_EMBEDDED_1
	TOKEN_WIDE_CHAR_EMBEDDED_2
	TOKEN_WIDE_CHAR_EMBEDDED_3
	TOKEN_STRING
	TOKEN_WIDE_STRING
	TOKEN_SPECIAL
	TOKEN_STREAMBEGIN
	TOKEN_STREAMEND
	TOKEN_MACRO_ARGUMENT
	TOKEN_STR_ARGUMENT
	TOKEN_QUOTED_ARGUMENT
	TOKEN_CONCAT
	TOKEN_GNU_KLUDGE
	TOKEN_UNTAINT
	TOKEN_ARG_COUNT
	TOKEN_IF
	TOKEN_SKIP_GROUPS
	TOKEN_ELSE

	SPECIAL_BASE
	SPECIAL_ADD_ASSIGN
	SPECIAL_INCREMENT
	SPECIAL_SUB_ASSIGN
	SPECIAL_DECREMENT
	SPECIAL_DEREFERENCE
	SPECIAL_MUL_ASSIGN
	SPECIAL_DIV_ASSIGN
	SPECIAL_MOD_ASSIGN
	SPECIAL_LTE
	SPECIAL_GTE
	SPECIAL_EQUAL
	SPECIAL_NOTEQUAL
	SPECIAL_LOGICAL_AND
	SPECIAL_AND_ASSIGN
	SPECIAL_LOGICAL_OR
	SPECIAL_OR_ASSIGN
	SPECIAL_XOR_ASSIGN
	SPECIAL_HASHHASH
	SPECIAL_LEFTSHIFT
	SPECIAL_RIGHTSHIFT
	SPECIAL_DOTDOT
	SPECIAL_SHL_ASSIGN
	SPECIAL_SHR_ASSIGN
	SPECIAL_ELLIPSIS
	SPECIAL_ARG_SEPARATOR
	SPECIAL_UNSIGNED_LT
	SPECIAL_UNSIGNED_GT
	SPECIAL_UNSIGNED_LTE
	SPECIAL_UNSIGNED_GTE

	EXPANSION_CMDLINE
	EXPANSION_STREAM
	EXPANSION_MACRO
	EXPANSION_MACROARG
	EXPANSION_CONCAT
	EXPANSION_PREPRO

        CONSTANT_FILE_MAYBE
        CONSTANT_FILE_IFNDEF
        CONSTANT_FILE_NOPE
        CONSTANT_FILE_YES

      )],

	);

    # Exporter::export_tags();
    {
	# De-duplicate the export list: 
	my %export;
	@export{map {@$_} values %EXPORT_TAGS} = ();
	# Doing the de-dup with a temporary hash has the advantage that the SVs in
	# @EXPORT are actually shared hash key scalars, which will save some memory.
	our @EXPORT = keys %export;

    }
    
    {
	my %seen;
	push @{$EXPORT_TAGS{all}},
	grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;
    }
    
    require Exporter;
}


use sparse::tok;


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

d - Perl extension for blah blah blah

=head1 SYNOPSIS

  use d;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for d, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

eiselekd, E<lt>eiselekd@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by eiselekd

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
