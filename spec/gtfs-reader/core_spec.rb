require 'spec_helper'

describe GtfsReader do
  it { expect( GtfsReader.config ).to be_a GtfsReader::Configuration }
  it { expect{ |b| GtfsReader.config &b }.to yield_with_args GtfsReader::Configuration }
end
