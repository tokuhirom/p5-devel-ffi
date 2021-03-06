use inc::Module::Install;
name 'Devel-FFI';
all_from 'lib/Devel/FFI.pm';

can_cc or die "This module requires a C compiler";

makemaker_args(
    OBJECT => '$(O_FILES)',
    CCFLAGS => '-g',
    LIBS => ['-lffi -lm'],
    clean => {
        FILES => q{
            *.stackdump
            *.gcov *.gcda *.gcno
            *.out
            nytprof
            cover_db
        },
    },
);

tests 't/*.t';
author_tests 'xt';
ppport();

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
