use strict;
use warnings;
use Devel::FFI;
use DynaLoader;

my $lib = DynaLoader::dl_load_file('libc.so');
my $fp = DynaLoader::dl_find_symbol($lib, 'printf');
die unless $fp;

Devel::FFI::call($fp, 'isid', "Hello, world! %d, %.2f\n", 4, 3.14);

