Given /^a hash of (\{.+\})$/ do |hash_str|
  hash = instance_eval hash_str
  raise "'#{hash}' is not a hash" unless Hash === hash
  @context = GtfsReader::HashContext.new hash
end

When /^I call context\.(.+)$/ do |method_name|
  @received = @context.send method_name.to_sym
end

Then(/^I should receive (.+)$/) do |expected|
  expect( @received ).to eq expected.to_i
end
