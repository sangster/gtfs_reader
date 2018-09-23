require 'simplecov'
SimpleCov.start # must be before other requires

require 'gtfs_reader'
require 'factory_bot'
FactoryBot.find_definitions

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

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

  config.before do
    GtfsReader::Log.logger do
      Object.new.tap do |obj|
        def obj.method_missing(_name, *_args)
          yield if block_given?
        end

        def obj.respond_to_missing?(_name, _include_private = false)
          true
        end
      end
    end
  end
end

module RSpec
  module Core
    module MemoizedHelpers
      def its(*methods)
        methods.inject(subject) { |obj, m| obj.__send__(m) }
      end
    end
  end
end
