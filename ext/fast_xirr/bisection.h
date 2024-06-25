#ifndef BISECTION_H
#define BISECTION_H

#include <ruby.h>

VALUE calculate_xirr_with_bisection(VALUE self, VALUE rb_cashflows, VALUE rb_tol, VALUE rb_max_iter);

#endif
