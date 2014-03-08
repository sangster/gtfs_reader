def config_context
  result = {}
  GtfsReader.config( result ) {|result| result[:context] = self }
  result[:context]
end

When /^I want to configure the reader with a block$/ do
  @context = config_context
end

Then /^it should be in the context of a configuration object$/ do
  expect( @context ).to be_a_kind_of GtfsReader::Configuration
end

Then /^it should have access to a feed definition$/ do
  expect( @context.feed_definition ).
    to be_a_kind_of GtfsReader::Config::FeedDefinition
end

Given /^the configuration has already been created$/ do
  @first_config = config_context
end

Then /^it should be in the context of the same configuration object$/ do
  expect( config_context ).to be @first_config
end

When /^I request the current configuration$/ do
  @config = GtfsReader.config
end

Then /^it should return the same configuration$/ do
  expect( @config ).to be @first_config
end

When /^I call config with arguments but no block$/ do
  @proc = ->{ GtfsReader.config :an_argument }
end

Given /^there is a configuration with the parameter (.+)$/ do |param|
  (@config = GtfsReader::Configuration.new).parameter param.to_sym
end

Given /^the parameter (\w+) is set to (.+)$/ do |param,value|
  @config.send param.to_sym, eval( value )
end

When /^I request the parameter (.+)$/ do |param|
  @return = @config.send param.to_sym
end

Then /^it should return the value (.+)$/ do |expected|
  expect( @return ).to eq eval( expected )
end

Given /^there is a (\w+) class with properties (.+)$/ do |type, attrs|
  (@classes ||= {})[ type ] = GtfsReader::HashContext
end

Given /^there is a ([^\s]+) block parameter that uses the (\w+) class$/ do |param, type|
  @config = GtfsReader.config
  @config.block_parameter param.to_sym, @classes[ type ]
end

When 'I execute:' do |code|
  GtfsReader.instance_eval "#{code}"
end

Then /^the returned object.s ([^\s]+) should be (.+)$/ do |param, value|
  expect( @return.send param.to_sym ).to eq eval( value )
end
