#include "brent.h"
#include "common.h"
#include <math.h>
#include <ruby.h>
#include <stdint.h>

/**
 * Brent's Method for finding the root of a function within a given interval.
 * This method combines root bracketing, bisection, secant, and inverse
 * quadratic interpolation.
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
double brent_method(CashFlow *cashflows, long long count, double tol,
                    long long max_iter, double low, double high) {
  // If cashflows are empty, return 0
  if (count == 0) {
    return 0.0;
  }

  // Calculate the NPV at the boundaries of the interval
  double fa = npv(low, cashflows, count, cashflows[0].date);
  double fb = npv(high, cashflows, count, cashflows[0].date);

  // Ensure the root is bracketed
  if (fa * fb > 0) {
    return NAN; // Root is not bracketed
  }

  double c = low, fc = fa, s, d = 0.0, e = 0.0;

  // Iteratively apply Brent's method
  for (long long iter = 0; iter < max_iter; iter++) {
    if (fb * fc > 0) {
      // Adjust c to ensure that f(b) and f(c) have opposite signs
      c = low;
      fc = fa;
      d = e = high - low;
    }
    if (fabs(fc) < fabs(fb)) {
      // Swap low and high to make f(b) smaller in magnitude
      low = high;
      high = c;
      c = low;
      fa = fb;
      fb = fc;
      fc = fa;
    }

    // Tolerance calculation for convergence check
    double tol1 = 2 * tol * fabs(high) + 0.5 * tol;
    double m = 0.5 * (c - high);

    // Check for convergence
    if (fabs(m) <= tol1 || fb == 0.0) {
      return high;
    }

    // Use inverse quadratic interpolation if conditions are met
    if (fabs(e) >= tol1 && fabs(fa) > fabs(fb)) {
      double p, q, r;
      s = fb / fa;
      if (low == c) {
        // Use the secant method
        p = 2 * m * s;
        q = 1 - s;
      } else {
        // Use inverse quadratic interpolation
        q = fa / fc;
        r = fb / fc;
        p = s * (2 * m * q * (q - r) - (high - low) * (r - 1));
        q = (q - 1) * (r - 1) * (s - 1);
      }
      if (p > 0)
        q = -q;
      p = fabs(p);
      if (2 * p < fmin(3 * m * q - fabs(tol1 * q), fabs(e * q))) {
        // Accept interpolation
        e = d;
        d = p / q;
      } else {
        // Use bisection
        d = m;
        e = m;
      }
    } else {
      // Use bisection
      d = m;
      e = m;
    }

    // Update bounds
    low = high;
    fa = fb;

    // Update the new high value
    if (fabs(d) > tol1) {
      high += d;
    } else {
      high += copysign(tol1, m);
    }
    fb = npv(high, cashflows, count, cashflows[0].date);
  }

  return NAN; // Failed to converge
}

/**
 * Ruby wrapping to calculate XIRR using Brent's method.
 *
 * @param self Ruby object (self).
 * @param rb_cashflows Ruby array of cash flows.
 * @param rb_tol Ruby float for tolerance.
 * @param rb_max_iter Ruby integer for maximum iterations.
 * @param rb_brackets Ruby array with [low, high] bounds for search interval, or
 * nil for defaults. Default interval is [-0.3, 10.0].
 *
 * @return Ruby float with the calculated XIRR.
 */
VALUE calculate_xirr_with_brent(VALUE self, VALUE rb_cashflows, VALUE rb_tol,
                                VALUE rb_max_iter, VALUE rb_brackets) {
  // Get the number of cash flows
  long long total_count = (long long)RARRAY_LEN(rb_cashflows);
  CashFlow cashflows[total_count];
  long long filtered_count = 0;

  // Convert Ruby cash flows array to C array, filtering out zero amounts
  for (long long i = 0; i < total_count; i++) {
    VALUE rb_cashflow = rb_ary_entry(rb_cashflows, i);
    double amount = NUM2DBL(rb_ary_entry(rb_cashflow, 0));
    if (amount != 0.0) {
      cashflows[filtered_count].amount = amount;
      cashflows[filtered_count].date = (int64_t)NUM2LL(rb_ary_entry(rb_cashflow, 1));
      filtered_count++;
    }
  }

  // Convert tolerance and max iterations to C types
  double tol = NUM2DBL(rb_tol);
  long long max_iter = NUM2LL(rb_max_iter);

  double result;
  double low = -0.3, high = 10.0;

  // Use provided brackets if they exist
  if (!NIL_P(rb_brackets)) {
    Check_Type(rb_brackets, T_ARRAY);
    if (RARRAY_LEN(rb_brackets) != 2) {
      rb_raise(rb_eArgError, "Bracket array must contain exactly 2 elements");
    }
    low = NUM2DBL(rb_ary_entry(rb_brackets, 0));
    high = NUM2DBL(rb_ary_entry(rb_brackets, 1));
  }

  result = brent_method(cashflows, filtered_count, tol, max_iter, low, high);
  if (!isnan(result)) {
    return rb_float_new(result);
  }

  // If the standard interval fails, try to find a better bracketing interval
  low = -0.9999999;
  high = 100.0;
  if (find_bracketing_interval(cashflows, filtered_count, &low, &high)) {
    result = brent_method(cashflows, filtered_count, tol, max_iter, low, high);
    return rb_float_new(result);
  }

  // If no interval is found, return NAN
  return rb_float_new(NAN);
}
