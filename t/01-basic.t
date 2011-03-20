package test::Base;
use strict;
use warnings;

use base qw(Test::Class);

use Teng::Schema::Declare;
use Teng::Schema::Declare::Columns::Struct;
use JSON::XS;

use Test::More;

my $klass = "Teng::TestFor::DeclareStructSchema";
my $schema = schema {
    table {
        name 'foo';
        columns qw(name struct);
        struct_columns qw(struct);
    };
} $klass;

sub _inflate_struct_ok : Test(5) {
    ok my $table = $schema->get_table("foo");

    my $struct      = [{test1 => 1}, {test2 => 2}];
    my $struct_text = encode_json $struct;
    my ($inflate, $deflate);

    # struct
    $deflate  = $table->call_deflate('struct', $struct);
    is $deflate, $struct_text;
    $inflate = $table->call_inflate('struct', $struct_text);
    is ref $inflate, 'ARRAY';
    is $inflate->[0]->{test1}, 1;
    is $inflate->[1]->{test2}, 2;
}

sub _inflate_struct_ng : Test(5) {
    ok my $table = $schema->get_table("foo");

    my $struct      = [{test1 => 1}, {test2 => 2}];
    my $struct_text = encode_json $struct;
    my ($inflate, $deflate);

    # name
    $deflate  = $table->call_deflate('name', $struct);
    is ref $deflate, 'ARRAY';
    is $deflate->[0]->{test1}, 1;
    is $deflate->[1]->{test2}, 2;
    $inflate = $table->call_inflate('name', $struct_text);
    is $inflate, $struct_text;
}

__PACKAGE__->runtests;

1;
