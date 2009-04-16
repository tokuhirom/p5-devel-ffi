use strict;
use warnings;
use Test::More tests => 6;
use Devel::FFI;
use DynaLoader;

my $mpath = DynaLoader::dl_findfile('m');
ok $mpath;
my $lib = DynaLoader::dl_load_file($mpath);
ok $lib;
my $fp = DynaLoader::dl_find_symbol($lib, 'sqrt');
ok $fp;
is Devel::FFI::call($fp, 'dd', 0.0), 0.0;
is Devel::FFI::call($fp, 'dd', 1.0), 1.0;
is Devel::FFI::call($fp, 'dd', 4.0), 2.0;

