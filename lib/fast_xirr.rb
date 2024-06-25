require 'fast_xirr/fast_xirr'

module FastXirr
  def self.calculate(cashflows, tol = 1e-7, max_iter = 100000000000000)
    cashflows_with_timestamps = cashflows.map do |amount, date|
      [amount, date.to_time.to_i]
    end
    result = _calculate_with_brent(cashflows_with_timestamps, tol, max_iter)

    if result.nan?
      result = _calculate_with_bisection(cashflows_with_timestamps, tol, max_iter)
    end

    { result: result }
  end

  def self.calculate_native(cashflows, tol, max_iter)
    FastXirr.calculate_internal(cashflows, tol, max_iter)
  end
end


