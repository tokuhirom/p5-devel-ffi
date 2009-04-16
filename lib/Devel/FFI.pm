package Devel::FFI;
use strict;
use warnings;
our $VERSION = '0.01';
our @ISA;
use DynaLoader;
use Devel::FFI::Func;

eval {
    require XSLoader;
    XSLoader::load(__PACKAGE__, $VERSION);
    1;
} or do {
    require DynaLoader;
    push @ISA, 'DynaLoader';
    __PACKAGE__->bootstrap($VERSION);
};

sub new_func {
    my ($class, $libname, $funcname, $proto) = @_;
    no warnings;
    my $mpath = DynaLoader::dl_findfile($libname);
    my $lib = DynaLoader::dl_load_file($mpath);
    my $fp = DynaLoader::dl_find_symbol($lib, $funcname);
    return sub {
        Devel::FFI::call($fp, $proto, @_)
    };
}

1;
__END__

=head1 NAME

Devel::FFI -

=head1 SYNOPSIS

    use Devel::FFI;
    my $func = Devel::FFI->new_func('c', 'strlen', 'it');
    $func->('ok'); # => 2

=head1 DESCRIPTION

Devel::FFI is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom ah! gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
