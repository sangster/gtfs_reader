require 'simplecov'
SimpleCov.start # must be before other requires

require 'gtfs_reader'
require 'factory_girl'
FactoryGirl.find_definitions


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.full_backtrace = true
    config.formatter = 'doc' if config.formatters.none?
  end

  config.profile_examples = 5
  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end


module RSpec::Core::MemoizedHelpers
  def is_expected
    expect subject
  end

  def its(*methods)
    methods.inject(subject) { |obj, m| obj.__send__ m }
  end
end
