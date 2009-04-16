use strict;
use warnings;
use Devel::FFI;
use DynaLoader;

DynaLoader::boot_DynaLoader();
my $mpath = DynaLoader::dl_findfile('libc.so');
die unless $mpath;
warn $mpath;
my $lib = DynaLoader::dl_load_file('libc.so');
my $fp = DynaLoader::dl_find_symbol($lib, 'puts');
die unless $fp;

Devel::FFI::call($fp, 'is', "Hello, world!");

