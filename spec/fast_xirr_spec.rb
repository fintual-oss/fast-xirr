require 'fast_xirr'
require 'date'

RSpec.describe FastXirr do
  describe '.calculate' do
    it 'calculates xirr with default parameters as expected' do
      cashflows = [
        [1000, Date.new(1985, 1, 1)],
        [-600, Date.new(1990, 1, 1)],
        [-6000, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows: cashflows)
      expect(result).to be_within(1e-6).of(0.22568333231765117)
    end

    it 'returns NaN with lower iteration limit' do
      cashflows = [
        [1000, Date.new(1985, 1, 1)],
        [-600, Date.new(1990, 1, 1)],
        [-6000, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows: cashflows, max_iter: 2)
      expect(result).to be_nan
    end

    it 'calculates xirr with more tolerance' do
      cashflows = [
        [1000, Date.new(1985, 1, 1)],
        [-600, Date.new(1990, 1, 1)],
        [-6000, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows: cashflows, tol: 1e-2)
      expect(result).not_to be_within(0.0000001).of(0.2256833323176)
      expect(result).to be_within(1e-2).of(0.22568333231765117)
    end

    it 'returns NaN with super low tolerance' do
      cashflows = [
        [1000, Date.new(1985, 1, 1)],
        [-600, Date.new(1990, 1, 1)],
        [-6000, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows: cashflows, max_iter: 1e6, tol: 1e-20)
      expect(result).to be_nan
    end

    it 'calculates xirr with super low tolerance and a lot of iterations' do
      cashflows = [
        [1000, Date.new(1985, 1, 1)],
        [-600, Date.new(1990, 1, 1)],
        [-6000, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows: cashflows, max_iter: 1e10, tol: 1e-13)
      expect(result).to be_within(1e-12).of(0.22568333231765117)
    end

    it 'returns 0 with an empty array of cash flows' do
      cashflows = []

      result = FastXirr.calculate(cashflows: cashflows)
      expect(result).to be_zero
    end
  end
end
