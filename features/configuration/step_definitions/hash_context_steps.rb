def context
  @context ||= GtfsReader::HashContext.new @hash
end

Given /^a hash of (\{.+\})$/ do |hash_str|
  @hash = instance_eval hash_str
  raise "'#{hash}' is not a hash" unless Hash === @hash
end

When /^I have a method call, [^\.]+\.(.+)$/ do |method_name|
  @method = method_name.to_sym
  @proc = ->{ context.send @method }
end

When 'I create a HashContext' do
  @proc = ->{ context }
end

Then /respond_to\? should return true for it/ do
  expect( context.respond_to?(@method) ).to be true
end

Then /^I should receive (.+)$/ do |expected|
  expect( @proc.call ).to eq eval expected
end
