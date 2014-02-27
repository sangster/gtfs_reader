require 'spec_helper'

describe GtfsReader::Config do
  subject(:format) { build :file_format, name: name }
  let(:name) { "bob" }
  
  context '#new' do
    it { expect( its :name ).to eq 'bob' }
    it { expect( its :filename ).to eq 'bob.txt' }
    it { expect( its :required_cols ).to be_empty }
    it { expect( its :optional_cols ).to be_empty }
    it { expect( its :unique_cols ).to be_empty }
  end

  it do
    expect {
      format.a
      format.b
    }.to change{ format.optional_cols.collect &:name }.to eq [:a, :b]
  end

  it do
    expect {
      format.a required: true
      format.b required: true
    }.to change{ format.required_cols.collect &:name }.to eq [:a, :b]
  end

  context 'same column twice' do
    it do
      expect {
        format.same
        format.same
      }.to change{ format.optional_cols.collect &:name }.to eq [:same]
    end

    it do
      expect {
        format.same required: true
        format.same required: true
      }.to change{ format.required_cols.collect &:name }.to eq [:same]
    end
  end
end
