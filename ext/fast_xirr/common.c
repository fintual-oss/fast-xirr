#include "common.h"
#include <math.h>

/**
 * Calculate the Net Present Value (NPV) for a given rate.
 *
 * @param rate The discount rate.
 * @param cashflows Array of CashFlow structures containing amount and date.
 * @param count Number of elements in the cashflows array.
 * @param min_date The earliest date in the cashflows array.
 *
 * @return The calculated NPV.
 */
double npv(double rate, CashFlow *cashflows, long count, time_t min_date) {
    double npv_value = 0.0;

    for (long i = 0; i < count; i++) {
        // Calculate the number of days from the minimum date to the cash flow date
        double days = difftime(cashflows[i].date, min_date) / (60 * 60 * 24);
        
        // Calculate the discount factor and add the discounted amount to the NPV
        npv_value += cashflows[i].amount / pow(1 + rate, days / 365.0);
    }

    return npv_value;
}



/**
 * Find a bracketing interval for the root using the NPV function.
 *
 * @param cashflows Array of CashFlow structures containing amount and date.
 * @param count Number of elements in the cashflows array.
 * @param low Pointer to store the lower bound of the bracketing interval.
 * @param high Pointer to store the upper bound of the bracketing interval.
 *
 * @return 1 if a bracketing interval is found, 0 otherwise.
 */
int find_bracketing_interval(CashFlow *cashflows, long count, double *low, double *high) {
    double min_rate = -0.99999999, max_rate = 10.0;
    double step = 0.0001;
    time_t min_date = cashflows[0].date;

    // Find the earliest date in the cashflows array
    for (long i = 1; i < count; i++) {
        if (cashflows[i].date < min_date) {
            min_date = cashflows[i].date;
        }
    }

    // Calculate NPV at the minimum rate
    double npv_min_rate = npv(min_rate, cashflows, count, min_date);

    // Search for a bracketing interval within the initial range
    for (double rate = min_rate + step; rate <= max_rate; rate += step) {
        double npv_rate = npv(rate, cashflows, count, min_date);

        // Check if the function values at consecutive rates have opposite signs
        if (npv_min_rate * npv_rate <= 0) {
            *low = rate - step;
            *high = rate;
            return 1;
        }
        npv_min_rate = npv_rate;
    }

    // Extend the search range if no interval is found within the initial range
    step = 10.0;
    for (double rate = max_rate + step; rate <= 10000.0; rate += step) {
        double npv_rate = npv(rate, cashflows, count, min_date);

        // Check if the function values at consecutive rates have opposite signs
        if (npv_min_rate * npv_rate < 0) {
            *low = rate - step;
            *high = rate;
            return 1;
        }
        npv_min_rate = npv_rate;
    }

    // If no bracketing interval is found, return 0
    return 0;
}

