use strict;
no warnings; # shut up uuv
use Test::More tests => 2;
use Devel::FFI;

my $func = Devel::FFI->new_func('c', 'strlen', 'it');
is $func->("ok"), 2;
is $func->("okk"), 3;

