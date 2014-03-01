require 'spec_helper'

describe GtfsReader::Config::FeedDefinition do
  subject(:feed) { build :feed_definition }

  it { expect( feed.respond_to? :any_method_name_here ).to be_truthy }
  it { expect( its :undefined_table ).to be_nil }
  it { expect{ feed.new_table {} }.to change { its :new_table } }

  context 'with a file defined' do
    before do
      feed.instance_eval do
        agency required: true do
          prefix :agency do
            name required: true
            url required: true
            timezone required: true
            id unique: true
            lang
            phone
            fare_url
          end
        end
      end
    end

    let(:required_names) { %w{agency_name agency_url agency_timezone} }
    let(:optional_names) { %w{agency_id agency_lang agency_phone agency_fare_url} }
    let(:unique_names) { %w{agency_id} }

    it { expect( its :agency, :id ).to be its :agency, :agency_id }
    it { expect( feed.files.collect( &:_name ) ).to eq [:agency] }

    it { expect( its( :agency, :required_cols ).collect( &:name ) ).to eq required_names }
    it { expect( its( :agency, :optional_cols ).collect( &:name ) ).to eq optional_names }
    it { expect( its( :agency, :unique_cols ).collect( &:name ) ).to eq unique_names }
  end
end
