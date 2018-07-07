require "bundler/setup"
require "rspec/expectations"
require "codebreaker"
require 'pry'


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :consist_from do |expected|
  match do |actual|
    in_a_range?(expected, actual)
  end

  def in_a_range?(expected, actual)
    fail "Expected Range or Array, but received #{expected.class}" unless [Array, Range].include?(expected.class)
    fail "Expected Array, but received #{actual.class}" unless actual.is_a?(Array)
    actual & expected.to_a == actual.uniq
  end
end
