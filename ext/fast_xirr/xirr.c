#include <ruby.h>
#include "brent.h"
#include "bisection.h"

/**
 * Initialize the FastXirr module and define its methods.
 */
void Init_fast_xirr(void) {
    VALUE XirrModule = rb_define_module("FastXirr");
    rb_define_singleton_method(XirrModule, "_calculate_with_bisection", calculate_xirr_with_bisection, 3);
    rb_define_singleton_method(XirrModule, "_calculate_with_brent", calculate_xirr_with_brent, 4);
}
