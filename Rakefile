# Bundler
require 'bundler/gem_tasks'

# Specs
require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = Dir.glob("spec/**/*_spec.rb")
end

task default: :test
