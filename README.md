# FastXirr

FastXirr is a high-performance Ruby gem for calculating the Extended Internal Rate of Return (XIRR). It leverages C under the hood for rapid calculations, making it suitable for performance-critical applications.

## Features

- Fast XIRR calculations using efficient algorithms
- Implemented in C for high performance
- Easy to use Ruby interface
- Includes both Brent's method and Bisection method for robust root-finding

## Installation

### From RubyGems

Add this line to your application's Gemfile:

```ruby
gem 'fast_xirr'
```

And then execute:
```bash
bundle install
```

### From CLI

```bash
gem install fast_xirr
```

## Usage

### Calculate XIRR

To calculate the XIRR for a series of cash flows, use the calculate method:

```ruby
require 'fast_xirr'
require 'date'

cashflows = [
  [1000, Date.new(1985, 1, 1)],
  [-600, Date.new(1990, 1, 1)],
  [-6000, Date.new(1995, 1, 1)]
]

result = FastXirr.calculate(cashflows: cashflows)
puts "XIRR: #{result}"
# => XIRR: 0.22568401743016633
```

If it is not possible to find a solution, the method will return `nan`.

```ruby
require 'fast_xirr'
require 'date'

result = FastXirr.calculate(cashflows: [[1000, Date.new(1985, 1, 1)]])

puts "XIRR: #{result}"
# => XIRR: NaN

result.nan?
# => true
```

Tolerance can be set to a custom value (default is 1e-7), as well as the maximum number of iterations (default is 1e10).


```ruby
require 'fast_xirr'
require 'date'

cashflows = [
  [1000, Date.new(1985, 1, 1)],
  [-600, Date.new(1990, 1, 1)],
  [-6000, Date.new(1995, 1, 1)]
]

result = FastXirr.calculate(cashflows: cashflows, tol: 1e-2, max_iter: 100)
puts "XIRR: #{result}"
# => XIRR: 0.22305878076614422

result = FastXirr.calculate(cashflows: cashflows, tol: 1e-8, max_iter: 2)
puts "XIRR: #{result}"
# => XIRR: NaN
```

## Build and test

### Building the Gem

To build the gem from the source code, follow these steps:

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/fintual-oss/fast-xirr.git
    cd fast_xirr
    ```

2. **Build the Gem**:

    ```bash
    gem build fast_xirr.gemspec
    ```

    This will create a `.gem` file in the directory, such as `fast_xirr-1.x.x.gem`.

3. **Install the Gem Locally**:

    ```bash
    gem install ./fast_xirr*.gem
    ```

### Testing the Gem

To run the tests, follow these steps:

1. **Install Development Dependencies**:

    ```bash
    bundle install
    ```

2. **Run the Tests**:

    ```bash
    rake test
    ```

    This will run the test suite using RSpec.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fintual-oss/fast-xirr. This project is intended to be a safe, welcoming space for collaboration.

