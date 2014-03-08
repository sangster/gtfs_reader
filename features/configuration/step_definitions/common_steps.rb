Then /^I should( not)? get an?( [^\s]+)? exception$/ do |negate, type|
  if !negate
    expect( &@proc ).to raise_exception
  else
    expect( &@proc ).not_to raise_an_exception type
  end
end
