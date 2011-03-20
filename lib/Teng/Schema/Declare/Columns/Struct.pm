package Teng::Schema::Declare::Columns::Struct;

use strict;
use warnings;
use Carp;

our $VERSION = '0.0.1';

use JSON::XS;
use base qw(Class::Data::Inheritable);
__PACKAGE__->mk_classdata(serializer   => sub {encode_json shift});
__PACKAGE__->mk_classdata(deserializer => sub {decode_json shift});

use Exporter::Lite;
our @EXPORT = qw(struct_columns);

sub struct_columns {
    my (@columns) = @_;

    my $columns_regexp = join('|', @columns);
    my $regexp = qr{^(?:$columns_regexp)$};
    my ($pkg) = caller;
    my $inflate = \&{$pkg . '::inflate'};
    my $deflate = \&{$pkg . '::deflate'};
    $inflate->($regexp => \&_inflate_struct);
    $deflate->($regexp => \&_deflate_struct);
}

sub _inflate_struct {
    my ($col_value) = @_;
    return __PACKAGE__->deserializer->($col_value);
}

sub _deflate_struct {
    my ($col_value) = @_;
    return __PACKAGE__->serializer->($col_value);
}

1;

__END__

=head1 NAME

Teng::Schema::Declare::Columns::Struct - [One line description of module's purpose here]


=head1 SYNOPSIS

    use Teng::Schema::Declare::Columns::Struct;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.


=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.

=head1 REPOSITORY

https://github.com/

=head1 AUTHOR

  C<< <shibayu36 {at} gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Yuki Shibazaki C<< <shibayu36 {at} gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
