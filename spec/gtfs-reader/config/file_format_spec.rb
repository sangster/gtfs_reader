require 'spec_helper'

describe GtfsReader::Config do
  subject(:format) { build :file_format, name: name, opts: opts }
  let(:name) { "bob" }
  let(:opts) { {} }
  
  context '#new' do
    it { expect( its :_name ).to eq 'bob' }
    it { expect( its :_filename ).to eq 'bob.txt' }
    it { expect( its :required_cols ).to be_empty }
    it { expect( its :optional_cols ).to be_empty }
    it { expect( its :unique_cols ).to be_empty }

    it { expect( format.respond_to? 'anything' ).to be_truthy }
    it { expect( format.respond_to? '_anything' ).to be_falsey }
  end

  it do
    expect {
      format.a
      format.b
    }.to change{ format.optional_cols.collect( &:name ) }.to eq [:a, :b]
  end

  it do
    expect {
      format.a required: true
      format.b required: true
    }.to change{ format.required_cols.collect( &:name ) }.to eq [:a, :b]
  end

  context 'same column twice' do
    it do
      expect {
        format.same
        format.same
      }.to change{ format.optional_cols.collect( &:name ) }.to eq [:same]
    end

    it do
      expect {
        format.same required: true
        format.same required: true
      }.to change{ format.required_cols.collect( &:name ) }.to eq [:same]
    end
  end

  context 'required file' do
    let(:opts) { {required: true} }
    it { expect( its :required? ).to be_truthy }
  end
end
