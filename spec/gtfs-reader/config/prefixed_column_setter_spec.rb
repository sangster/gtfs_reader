require 'spec_helper'

describe GtfsReader::Config::PrefixedColumnSetter do
  subject :setter do
    GtfsReader::Config::PrefixedColumnSetter.new definition, prefix
  end

  let(:prefix) { 'prefix' }
  let(:definition) { double 'definition' }

  it do
    expect( definition ).to receive( :col ).
      with :prefix_column, {a:1, b:2, alias: :column}

    setter.col :column, a: 1, b: 2
  end
end
