require 'spec_helper.rb'

describe GtfsReader::Configuration do
  subject(:cfg) { GtfsReader::Configuration.new }
  it { expect( cfg.tables ).not_to be_nil }
end
