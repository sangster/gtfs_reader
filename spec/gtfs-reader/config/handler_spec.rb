require 'gtfs_reader/config/handler'

describe GtfsReader::Config::Handler do
  subject { GtfsReader::Config::Handler }
  let(:row) { 'row' }

  it { expect{ subject.new }.to raise_exception }
  it { expect{ subject.new {} }.not_to raise_exception }
  it { expect{|b| subject.new( &b ).call row }.to yield_with_args row  }
end
