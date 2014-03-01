require 'spec_helper'

describe GtfsReader::Config do
  subject(:definition) { build :file_definition, name: name, opts: opts }
  let(:name) { "bob" }
  let(:opts) { {} }
  
  describe :new do
    it { expect( its :_name ).to eq 'bob' }
    it { expect( its :_filename ).to eq 'bob.txt' }
    it { expect( its :required_columns ).to be_empty }
    it { expect( its :optional_columns ).to be_empty }
    it { expect( its :unique_columns ).to be_empty }
    it { expect( its :to_s ).not_to be_empty }

    it { expect( definition.respond_to? 'anything' ).to be_truthy }
    it { expect( definition.respond_to? '_anything' ).to be_falsey }
    it { expect( definition.a_col ).to be_a_kind_of GtfsReader::Config::Column }
  end

  it do
    expect {
      definition.a
      definition.b
    }.to change{ definition.optional_columns.collect( &:name ) }.
      to eq [:a, :b]
  end

  it do
    expect {
      definition.a required: true
      definition.b required: true
    }.to change{ definition.required_columns.collect( &:name ) }.
      to eq [:a, :b]
  end

  context 'same column twice' do
    it do
      expect {
        definition.same
        definition.same
      }.to change{ definition.optional_columns.collect( &:name ) }.
        to eq [:same]
    end

    it do
      expect {
        definition.same required: true
        definition.same required: true
      }.to change{ definition.required_columns.collect( &:name ) }.
        to eq [:same]
    end
  end

  context 'required file' do
    let(:opts) { {required: true} }
    it { expect( its :required? ).to be_truthy }
  end

  describe :output_map do
    subject(:map) { definition.output_map input }
    let(:input) { {a: 1, b: 2, c: 3, d: 4} }
    let(:expected) { [:a, :b, :c, :d] }

    it{ expect( map ).not_to be_nil }
    it { expect( input.values.collect { |i| map.call i }  ).to eq expected }

    context 'with a default' do
      let(:default) { :default }
    end

    context 'with duplicate values' do
      let(:expected) { GtfsReader::Config::FileDefinitionError }
      let(:input) { {a: 1, b: 1} }
      it { expect{ map }.to raise_error expected }
    end
  end
end
