require 'spec_helper'

describe GtfsReader::HashContext do
  subject( :context ) { GtfsReader::HashContext.new hash }
  let( :hash ) { {a: 1, b: 2, c: 3, d: 4, e: 5} }

  it { expect( [:a, :b, :c, :d, :e].collect {|s| context.send s } ).
    to eq [1, 2, 3, 4, 5] }
    it { expect( [:a, :b, :c, :d, :e].all? {|s| context.respond_to? s } ).
    to be_truthy }
  it { expect{ context.unknown_key }.to raise_exception }
end
