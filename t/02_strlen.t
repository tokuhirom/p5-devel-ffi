use strict;
no warnings; # shut up uuv
use Test::More tests => 4;
use Devel::FFI;
use DynaLoader;

my $mpath = DynaLoader::dl_findfile('c');
ok $mpath;
my $lib = DynaLoader::dl_load_file($mpath);
my $fp = DynaLoader::dl_find_symbol($lib, 'strlen');
ok $fp;
is Devel::FFI::call($fp, 'it', "ok"), 2;
is Devel::FFI::call($fp, 'it', "okk"), 3;

