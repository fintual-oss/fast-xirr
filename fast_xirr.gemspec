Gem::Specification.new do |spec|
  spec.name          = "fast_xirr"
  spec.version       = "0.1.0"
  spec.authors       = ["Matias Martini"]
  spec.email         = ["martini@fintual.com"]

  spec.summary       = "XIRR calculation in Ruby with C extension"
  spec.description   = "A gem to calculate the XIRR using a C extension for performance."
  spec.homepage      = "https://github.com/fintual/fast_xirr"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb", "ext/**/*.{c,h,rb}", "README.md"]
  spec.extensions    = ["ext/fast_xirr/extconf.rb"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fintual/fast_xirr"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  spec.required_ruby_version = ">= 2.3.0"
end

