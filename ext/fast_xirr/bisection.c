#include <ruby.h>
#include <stdint.h>
#include <math.h>
#include "bisection.h"
#include "common.h"

/**
 * Bisection Method for finding the root of a function within a given interval.
 * This method iteratively narrows the interval where the root is located by halving the interval.
 *
 * @param cashflows Array of CashFlow structures containing amount and date.
 * @param count Number of elements in the cashflows array.
 * @param tol Tolerance for convergence.
 * @param max_iter Maximum number of iterations.
 * @param low Lower bound of the initial interval.
 * @param high Upper bound of the initial interval.
 *
 * @return The estimated root (XIRR) or NAN if it fails to converge.
 */
double bisection_method(CashFlow *cashflows, long long count, double tol, long long max_iter, double low, double high) {
    double mid, f_low, f_mid, f_high;

    // Calculate the NPV at the boundaries of the interval
    f_low = npv(low, cashflows, count, cashflows[0].date);
    f_high = npv(high, cashflows, count, cashflows[0].date);

    // Ensure the root is bracketed
    if (f_low * f_high > 0) {
        return NAN; // Root is not bracketed
    }

    // Iteratively apply the bisection method
    for (long long iter = 0; iter < max_iter; iter++) {
        mid = (low + high) / 2.0;
        f_mid = npv(mid, cashflows, count, cashflows[0].date);

        // Check for convergence
        if (fabs(f_mid) < tol || fabs(high - low) < tol) {
            return mid;
        }

        // Narrow the interval
        if (f_low * f_mid < 0) {
            high = mid;
            f_high = f_mid;
        } else {
            low = mid;
            f_low = f_mid;
        }
    }

    // If we reach here, it means we failed to converge
    return NAN;
}

/**
 * Ruby wrapper to calculate XIRR using the Bisection method.
 *
 * @param self Ruby object (self).
 * @param rb_cashflows Ruby array of cash flows.
 * @param rb_tol Ruby float for tolerance.
 * @param rb_max_iter Ruby integer for maximum iterations.
 *
 * @return Ruby float with the calculated XIRR.
 */
VALUE calculate_xirr_with_bisection(VALUE self, VALUE rb_cashflows, VALUE rb_tol, VALUE rb_max_iter) {
    // Get the number of cash flows
    long long count = RARRAY_LEN(rb_cashflows);
    CashFlow cashflows[count];

    // Convert Ruby cash flows array to C array
    for (long long i = 0; i < count; i++) {
        VALUE rb_cashflow = rb_ary_entry(rb_cashflows, i);
        cashflows[i].amount = NUM2DBL(rb_ary_entry(rb_cashflow, 0));
        cashflows[i].date = (int64_t)NUM2LL(rb_ary_entry(rb_cashflow, 1));
    }

    // Convert tolerance and max iterations to C types
    double tol = NUM2DBL(rb_tol);
    long long max_iter = NUM2LL(rb_max_iter);

    // Initial standard bracketing interval
    double low = -0.999999, high = 100.0;

    // Try Bisection method with the standard interval
    double result = bisection_method(cashflows, count, tol, max_iter, low, high);
    if (!isnan(result)) {
        return rb_float_new(result);
    }

    // If the standard interval fails, try to find a better bracketing interval
    low = -0.9999999; high = 1000.0;
    if (find_bracketing_interval(cashflows, count, &low, &high)) {
        result = bisection_method(cashflows, count, tol, max_iter, low, high);
        return rb_float_new(result);
    }

    // If no interval is found, return NAN
    return rb_float_new(NAN);
}
