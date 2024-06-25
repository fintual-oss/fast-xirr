#ifndef BRENT_H  
#define BRENT_H

#include <ruby.h>

VALUE calculate_xirr_with_brent(VALUE self, VALUE rb_cashflows, VALUE rb_tol, VALUE rb_max_iter);

#endif

