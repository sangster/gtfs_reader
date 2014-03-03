def context
  @context ||= GtfsReader::HashContext.new @hash
end

Given /^a hash of (\{.+\})$/ do |hash_str|
  @hash = instance_eval hash_str
  raise "'#{hash}' is not a hash" unless Hash === @hash
end

When /^I have a method call, context\.(.+)$/ do |method_name|
  @method = method_name.to_sym
  @proc = Proc.new { context.send @method }
end

When 'I create a HashContext' do
  @proc = Proc.new { context }
end

Then 'respond_to? should return true for it' do
  expect( context.respond_to?(@method) ).to be_truthy
end

Then /^I should receive (.+)$/ do |expected|
  expect( @proc.call ).to eq expected.to_i
end

Then /^I should( not)? get an?( [^\s]+)? exception$/ do |negate, type|
  if !negate
    expect( &@proc ).to raise_exception
  else
    expect( &@proc ).not_to raise_an_exception type
  end
end
