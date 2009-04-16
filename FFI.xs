#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include <ffi.h>
#ifdef __cplusplus
}
#endif

typedef union {
    int i;
    double d;
} myret;

MODULE = Devel::FFI  PACKAGE = Devel::FFI

SV*
call(IV fp, SV *proto_s, ...)
CODE:
    ffi_cif cif;
    STRLEN protolen;
    char * proto = SvPV(proto_s, protolen);
    if (protolen+1 != items) {
        Perl_croak(aTHX_ "Usage: Devel::FFI::call(fp, 'dd', ...)");
    }

    /* return value */
    ffi_type *ret_type;
    char retproto = *proto++;
    switch(retproto) {
    case 'i':
        ret_type = &ffi_type_sint32;
        break;
    case 'd':
        ret_type = &ffi_type_double;
        break;
    default:
        Perl_croak(aTHX_ "This type doesn't supported yet: %c", *(proto-1));
        break;
    }

    /* arguments */
    ffi_type **arg_types;
    void **arg_values;
    Newx(arg_types, protolen-1, ffi_type*);
    Newx(arg_values, protolen-1, void*);
    int i;
    for (i=0; i<protolen-1; i++) {
        SV * cur = ST(i+2);
        switch (*(proto+i)) {
        case 'i':
            arg_types[i] = &ffi_type_sint;
            arg_values[i] = &SvIVX(cur);
            break;
        case 'f':
            arg_types[i] = &ffi_type_float;
            arg_values[i] = &SvNVX(cur);
            break;
        case 'd':
            arg_types[i] = &ffi_type_double;
            arg_values[i] = &SvNVX(cur);
            break;
        case 't': /* string */
            arg_types[i] = &ffi_type_pointer;
            char * p = SvPVx_nolen(cur);
            arg_values[i] = &p;
            break;
        case 's': /* short */
            arg_types[i] = &ffi_type_sshort;
            arg_values[i] = &SvIVX(cur);
            break;
        default:
            Perl_croak(aTHX_ "unknown type: %c", *(proto+i));
            break;
        }
    }

    /* initialize */
    ffi_prep_cif(&cif, FFI_DEFAULT_ABI, protolen-1, ret_type, arg_types);
    myret ret;
    ffi_call(&cif, FFI_FN(INT2PTR(void*, fp)), &ret, arg_values);

    /* set return value */
    switch (retproto) {
    case 'i':
        RETVAL = newSViv(ret.i);
        break;
    case 'd':
        RETVAL = newSVnv(ret.d);
        break;
    case 'v':
        RETVAL = &PL_sv_undef;
        break;
    default:
        Perl_croak(aTHX_ "wtf? %c\n", retproto);
        break;
    }
OUTPUT:
    RETVAL

