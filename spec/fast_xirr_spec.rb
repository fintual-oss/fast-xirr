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
      expect(result).to be_within(0.0000001).of(0.22568401)
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
      expect(result).not_to be_within(0.0000001).of(0.22568430)
      expect(result).to be_within(0.01).of(0.22568401)
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

      result = FastXirr.calculate(cashflows: cashflows, max_iter: 1e10, tol: 1e-15)
      expect(result).to be_within(1e-15).of(0.22568402422255124)
    end
  end
end
