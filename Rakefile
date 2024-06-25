require 'rake/extensiontask'
require 'rake/testtask'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
Rake::ExtensionTask.new('fast_xirr') do |ext|
  ext.lib_dir = 'lib'
  ext.ext_dir = 'ext/fast_xirr'
  ext.config_script = 'extconf.rb'
end

task :test => :spec
task default: [:compile]
