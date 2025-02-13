#ifndef COMMON_H
#define COMMON_H

#include <stdint.h>

typedef struct {
  double amount;
  int64_t date;
} CashFlow;

double npv(double rate, CashFlow *cashflows, long long count, int64_t min_date);

int find_bracketing_interval(CashFlow *cashflows, long long count, double *low,
                             double *high);

#endif
