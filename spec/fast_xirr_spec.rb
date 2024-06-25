require 'fast_xirr'
require 'date'

RSpec.describe FastXirr do
  describe '.calculate' do
    it 'calculates xirr for an ok investment' do
      cashflows = [
        [1000, Date.new(1985, 1, 1)],
        [-600, Date.new(1990, 1, 1)],
        [-6000, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.000001).of(0.225684)
    end

    it 'calculates xirr for an inverted ok investment' do
      cashflows = [
        [-1000, Date.new(1985, 1, 1)],
        [600, Date.new(1990, 1, 1)],
        [6000, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.000001).of(0.22568430)
    end

    it 'calculates xirr for a very good investment' do
      cashflows = [
        [-1000000, Date.today - 180],
        [2200000, Date.today - 60],
        [800000, Date.today - 30]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.000001).of(22.352206)
    end

    it 'returns NaN for a good investment that cannot be annualized' do
      cashflows = [
        [-1000, Date.new(1985, 1, 1)],
        [6000, Date.new(1985, 1, 2)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result.nan?).to be true
    end

    it 'returns NaN for all negative cashflows' do
      cashflows = [
        [-600, Date.new(1990, 1, 1)],
        [-600, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result.nan?).to be true
    end

    it 'calculates xirr for a bad investment' do
      cashflows = [
        [-1000, Date.new(1985, 1, 1)],
        [600, Date.new(1990, 1, 1)],
        [200, Date.new(1995, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.000001).of(-0.034592)
    end

    it 'calculates xirr for a long investment' do
      cashflows = [
        [-1000, Date.new(1957, 1, 1)],
        [390000, Date.new(2013, 1, 1)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.000001).of(0.112339)
    end

    it 'calculates xirr for repeated cashflows' do
      cashflows = [
        [1000.0, Date.new(2011, 12, 7)],
        [2000.0, Date.new(2011, 12, 7)],
        [-2000.0, Date.new(2013, 5, 21)],
        [-4000.0, Date.new(2013, 5, 21)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.0001).of(0.61035894)
    end

    it 'returns NaN for a real case' do
      cashflows = [
        [-105187.06, Date.new(2011, 12, 7)],
        [-816709.66, Date.new(2011, 12, 7)],
        [-479069.684, Date.new(2011, 12, 7)],
        [-937309.708, Date.new(2012, 1, 18)],
        [-88622.661, Date.new(2012, 7, 3)],
        [-100000.0, Date.new(2012, 7, 3)],
        [-80000.0, Date.new(2012, 7, 19)],
        [-403627.95, Date.new(2012, 7, 23)],
        [-508117.9, Date.new(2012, 7, 23)],
        [-789706.87, Date.new(2012, 7, 23)],
        [88622.661, Date.new(2012, 9, 11)],
        [789706.871, Date.new(2012, 9, 11)],
        [688117.9, Date.new(2012, 9, 11)],
        [403627.95, Date.new(2012, 9, 11)],
        [-403627.95, Date.new(2012, 9, 12)],
        [-789706.871, Date.new(2012, 9, 12)],
        [-88622.661, Date.new(2012, 9, 12)],
        [-688117.9, Date.new(2012, 9, 12)],
        [-45129.14, Date.new(2013, 3, 11)],
        [-26472.08, Date.new(2013, 3, 11)],
        [-51793.2, Date.new(2013, 3, 11)],
        [-126605.59, Date.new(2013, 3, 11)],
        [-278532.29, Date.new(2013, 3, 28)],
        [-99284.1, Date.new(2013, 3, 28)],
        [-58238.57, Date.new(2013, 3, 28)],
        [-113945.03, Date.new(2013, 3, 28)],
        [-405137.88, Date.new(2013, 5, 21)],
        [405137.88, Date.new(2013, 5, 21)],
        [-165738.23, Date.new(2013, 5, 21)],
        [165738.23, Date.new(2013, 5, 21)],
        [-144413.24, Date.new(2013, 5, 21)],
        [-84710.65, Date.new(2013, 5, 21)],
        [84710.65, Date.new(2013, 5, 21)],
        [144413.24, Date.new(2013, 5, 21)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result.nan?).to be true
    end

    it 'returns NaN for another real case' do
      cashflows = [
        [-100, Date.new(2020, 1, 1)],
        [-100, Date.new(2020, 1, 2)],
        [1, Date.new(2020, 1, 3)],
        [0, Date.new(2020, 1, 5)],
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result.nan?).to be true
    end

    it 'calculates xirr for a complex case' do
      cashflows = [
        [-200000, Date.new(2023, 5, 22)],
        [-256938, Date.new(2023, 6, 9)],
        [474156, Date.new(2023, 6, 12)],
        [-4999999.999, Date.new(2024, 1, 17)],
        [-4995000.001, Date.new(2024, 1, 22)],
        [10874313.59, Date.new(2024, 2, 13)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.000001).of(2.505209)
    end

    it 'calculates xirr for another complex case' do
      cashflows = [
        [-10000, Date.new(2014, 4, 15)],
        [305.6, Date.new(2014, 5, 15)],
        [500, Date.new(2014, 10, 19)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.000001).of(-0.996814607)
    end

    it 'calculates xirr for a simple case' do
      cashflows = [
        [900.0, Date.new(2014, 11, 7)],
        [-13.5, Date.new(2015, 5, 6)]
      ]

      result = FastXirr.calculate(cashflows)[:result]
      expect(result).to be_within(0.0001).of(-0.9998)
    end
  end
end
