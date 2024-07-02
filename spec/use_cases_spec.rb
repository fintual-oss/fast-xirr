require 'fast_xirr'
require 'date'

RSpec.describe FastXirr do
  it 'calculates xirr for an ok investment' do
    cashflows = [
      [1000, Date.new(1985, 1, 1)],
      [-600, Date.new(1990, 1, 1)],
      [-6000, Date.new(1995, 1, 1)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(0.22568333231765117)
  end

  it 'calculates xirr for an inverted ok investment' do
    cashflows = [
      [-1000, Date.new(1985, 1, 1)],
      [600, Date.new(1990, 1, 1)],
      [6000, Date.new(1995, 1, 1)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(0.22568333231765117)
  end

  it 'calculates xirr for a very good investment' do
    cashflows = [
      [-1000000, Date.today - 180],
      [2200000, Date.today - 60],
      [800000, Date.today - 30]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(22.35220616417055)
  end

  it 'returns NaN for a good investment that cannot be annualized' do
    cashflows = [
      [-1000, Date.new(1985, 1, 1)],
      [6000, Date.new(1985, 1, 2)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result.nan?).to be true
  end

  it 'returns NaN for all negative cashflows' do
    cashflows = [
      [-600, Date.new(1990, 1, 1)],
      [-600, Date.new(1995, 1, 1)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result.nan?).to be true
  end

  it 'calculates xirr for a bad investment' do
    cashflows = [
      [-1000, Date.new(1985, 1, 1)],
      [600, Date.new(1990, 1, 1)],
      [200, Date.new(1995, 1, 1)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(-0.03459243361066291)
  end

  it 'calculates xirr for a long investment' do
    cashflows = [
      [-1000, Date.new(1957, 1, 1)],
      [390000, Date.new(2013, 1, 1)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(0.11233945341957301)
  end

  it 'calculates xirr for repeated cashflows' do
    cashflows = [
      [1000.0, Date.new(2011, 12, 7)],
      [2000.0, Date.new(2011, 12, 7)],
      [-2000.0, Date.new(2013, 5, 21)],
      [-4000.0, Date.new(2013, 5, 21)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(0.6103589452617378)
  end

  it 'returns expected xirr for a real case with a lot of cashflows' do
    cashflows = [
      [-2.002, Date.new(2024, 1, 2)],
      [2.004, Date.new(2024, 1, 3)],
      [-6.018, Date.new(2024, 1, 4)],
      [4.016, Date.new(2024, 1, 5)],
      [-10.05, Date.new(2024, 1, 6)],
      [6.036, Date.new(2024, 1, 7)],
      [-14.098, Date.new(2024, 1, 8)],
      [8.064, Date.new(2024, 1, 9)],
      [-18.162, Date.new(2024, 1, 10)],
      [10.1, Date.new(2024, 1, 11)],
      [-22.242, Date.new(2024, 1, 12)],
      [12.144, Date.new(2024, 1, 13)],
      [-26.338, Date.new(2024, 1, 14)],
      [14.196, Date.new(2024, 1, 15)],
      [-30.45, Date.new(2024, 1, 16)],
      [16.256, Date.new(2024, 1, 17)],
      [-34.578, Date.new(2024, 1, 18)],
      [18.324, Date.new(2024, 1, 19)],
      [-38.722, Date.new(2024, 1, 20)],
      [20.4, Date.new(2024, 1, 21)],
      [-42.882, Date.new(2024, 1, 22)],
      [22.484, Date.new(2024, 1, 23)],
      [-47.058, Date.new(2024, 1, 24)],
      [24.576, Date.new(2024, 1, 25)],
      [-51.25, Date.new(2024, 1, 26)],
      [26.676, Date.new(2024, 1, 27)],
      [-55.458, Date.new(2024, 1, 28)],
      [28.784, Date.new(2024, 1, 29)],
      [-59.682, Date.new(2024, 1, 30)],
      [30.9, Date.new(2024, 1, 31)],
      [-63.922, Date.new(2024, 2, 1)],
      [33.024, Date.new(2024, 2, 2)],
      [-68.178, Date.new(2024, 2, 3)],
      [35.156, Date.new(2024, 2, 4)],
      [-72.45, Date.new(2024, 2, 5)],
      [37.296, Date.new(2024, 2, 6)],
      [-76.738, Date.new(2024, 2, 7)],
      [39.444, Date.new(2024, 2, 8)],
      [-81.042, Date.new(2024, 2, 9)],
      [41.6, Date.new(2024, 2, 10)],
      [-85.362, Date.new(2024, 2, 11)],
      [43.764, Date.new(2024, 2, 12)],
      [-89.698, Date.new(2024, 2, 13)],
      [45.936, Date.new(2024, 2, 14)],
      [-94.05, Date.new(2024, 2, 15)],
      [48.116, Date.new(2024, 2, 16)],
      [-98.418, Date.new(2024, 2, 17)],
      [50.304, Date.new(2024, 2, 18)],
      [-102.802, Date.new(2024, 2, 19)],
      [52.5, Date.new(2024, 2, 20)],
      [-107.202, Date.new(2024, 2, 21)],
      [54.704, Date.new(2024, 2, 22)],
      [-111.618, Date.new(2024, 2, 23)],
      [56.916, Date.new(2024, 2, 24)],
      [-116.05, Date.new(2024, 2, 25)],
      [59.136, Date.new(2024, 2, 26)],
      [-120.498, Date.new(2024, 2, 27)],
      [61.364, Date.new(2024, 2, 28)],
      [-124.962, Date.new(2024, 2, 29)],
      [63.6, Date.new(2024, 3, 1)],
      [-129.442, Date.new(2024, 3, 2)],
      [65.844, Date.new(2024, 3, 3)],
      [-133.938, Date.new(2024, 3, 4)],
      [68.096, Date.new(2024, 3, 5)],
      [-138.45, Date.new(2024, 3, 6)],
      [70.356, Date.new(2024, 3, 7)],
      [-142.978, Date.new(2024, 3, 8)],
      [72.624, Date.new(2024, 3, 9)],
      [-147.522, Date.new(2024, 3, 10)],
      [74.9, Date.new(2024, 3, 11)],
      [-152.082, Date.new(2024, 3, 12)],
      [77.184, Date.new(2024, 3, 13)],
      [-156.658, Date.new(2024, 3, 14)],
      [79.476, Date.new(2024, 3, 15)],
      [-161.25, Date.new(2024, 3, 16)],
      [81.776, Date.new(2024, 3, 17)],
      [-165.858, Date.new(2024, 3, 18)],
      [84.084, Date.new(2024, 3, 19)],
      [-170.482, Date.new(2024, 3, 20)],
      [86.4, Date.new(2024, 3, 21)],
      [-175.122, Date.new(2024, 3, 22)],
      [88.724, Date.new(2024, 3, 23)],
      [-179.778, Date.new(2024, 3, 24)],
      [91.056, Date.new(2024, 3, 25)],
      [-184.45, Date.new(2024, 3, 26)],
      [93.396, Date.new(2024, 3, 27)],
      [-189.138, Date.new(2024, 3, 28)],
      [95.744, Date.new(2024, 3, 29)],
      [-193.842, Date.new(2024, 3, 30)],
      [98.1, Date.new(2024, 3, 31)],
      [-198.562, Date.new(2024, 4, 1)],
      [100.464, Date.new(2024, 4, 2)],
      [-203.298, Date.new(2024, 4, 3)],
      [102.836, Date.new(2024, 4, 4)],
      [-208.05, Date.new(2024, 4, 5)],
      [105.216, Date.new(2024, 4, 6)],
      [-212.818, Date.new(2024, 4, 7)],
      [107.604, Date.new(2024, 4, 8)],
      [-217.602, Date.new(2024, 4, 9)],
      [110, Date.new(2024, 4, 10)],
      [-222.402, Date.new(2024, 4, 11)],
      [112.404, Date.new(2024, 4, 12)],
      [-227.218, Date.new(2024, 4, 13)],
      [114.816, Date.new(2024, 4, 14)],
      [-232.05, Date.new(2024, 4, 15)],
      [117.236, Date.new(2024, 4, 16)],
      [-236.898, Date.new(2024, 4, 17)],
      [119.664, Date.new(2024, 4, 18)],
      [-241.762, Date.new(2024, 4, 19)],
      [122.1, Date.new(2024, 4, 20)],
      [-246.642, Date.new(2024, 4, 21)],
      [124.544, Date.new(2024, 4, 22)],
      [-251.538, Date.new(2024, 4, 23)],
      [126.996, Date.new(2024, 4, 24)],
      [-256.45, Date.new(2024, 4, 25)],
      [129.456, Date.new(2024, 4, 26)],
      [-261.378, Date.new(2024, 4, 27)],
      [131.924, Date.new(2024, 4, 28)],
      [-266.322, Date.new(2024, 4, 29)],
      [134.4, Date.new(2024, 4, 30)],
      [-271.282, Date.new(2024, 5, 1)],
      [136.884, Date.new(2024, 5, 2)],
      [-276.258, Date.new(2024, 5, 3)],
      [139.376, Date.new(2024, 5, 4)],
      [-281.25, Date.new(2024, 5, 5)],
      [141.876, Date.new(2024, 5, 6)],
      [-286.258, Date.new(2024, 5, 7)],
      [144.384, Date.new(2024, 5, 8)],
      [-291.282, Date.new(2024, 5, 9)],
      [146.9, Date.new(2024, 5, 10)],
      [-296.322, Date.new(2024, 5, 11)],
      [149.424, Date.new(2024, 5, 12)],
      [-301.378, Date.new(2024, 5, 13)],
      [151.956, Date.new(2024, 5, 14)],
      [-306.45, Date.new(2024, 5, 15)],
      [154.496, Date.new(2024, 5, 16)],
      [-311.538, Date.new(2024, 5, 17)],
      [157.044, Date.new(2024, 5, 18)],
      [-316.642, Date.new(2024, 5, 19)],
      [159.6, Date.new(2024, 5, 20)],
      [5506.2, Date.new(2024, 6, 21)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(0.21760561258980923)
  end

  it 'returns NaN for another real case' do
    cashflows = [
      [-100, Date.new(2020, 1, 1)],
      [-100, Date.new(2020, 1, 2)],
      [1, Date.new(2020, 1, 3)],
      [0, Date.new(2020, 1, 5)],
    ]

    result = FastXirr.calculate(cashflows: cashflows)
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

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(2.505209187174613)
  end

  it 'calculates xirr for another complex case with results on the verge of divergence' do
    cashflows = [
      [-10000, Date.new(2014, 4, 15)],
      [305.6, Date.new(2014, 5, 15)],
      [500, Date.new(2014, 10, 19)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(-0.9968146068978457)
  end

  it 'calculates xirr for a simple case on the verge of divergence' do
    cashflows = [
      [900.0, Date.new(2014, 11, 7)],
      [-13.5, Date.new(2015, 5, 6)]
    ]

    result = FastXirr.calculate(cashflows: cashflows)
    expect(result).to be_within(1e-6).of(-0.9997997749612346)
  end

  it 'calculate xirr in extreme conditions' do
    cashflows = [
      [-1000, Date.new(1985, 1, 1)],
      [383.325, Date.new(1985, 1, 20)],
    ]

    result = FastXirr.calculate(cashflows: cashflows, max_iter: 1e10, tol: 1e-6)
    expect(result).to be_within(1e-6).of(-0.9999999899975666)
  end
end
