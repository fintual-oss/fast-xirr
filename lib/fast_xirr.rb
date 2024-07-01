require 'fast_xirr/fast_xirr'

module FastXirr
  def self.calculate(cashflows:, tol: 1e-7, max_iter: 1e10)
    cashflows_with_timestamps = cashflows.map do |amount, date|
      [amount, Time.utc(date.year, date.month, date.day).to_i]
    end
    result = _calculate_with_brent(cashflows_with_timestamps, tol, max_iter)
    
    if result.nan?
      result = _calculate_with_bisection(cashflows_with_timestamps, tol, max_iter)
    end

    return result
  end
end


