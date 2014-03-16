describe GtfsReader::Config::FeedDefinition do
  subject(:feed) do
    GtfsReader::Config::FeedDefinition.new.tap do |feed|
      feed.instance_exec( &definition )
    end
  end

  let :definition do
    Proc.new do
      routes { col_1; col_2 required: true }
      trips { col_1; col_2 optional: true }
    end
  end

  it { expect( feed.respond_to? :any_method_name_here ).to be true }
  it { expect( its :undefined_table ).to be_nil }
  it { expect{ feed.new_table {} }.to change { its :new_table } }
  it { expect( its :to_s ).not_to be_empty }

  context 'with a file defined' do
    let(:definition) do
      Proc.new do
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
    it { expect( feed.files!.collect( &:_name ) ).to eq [:agency] }

    it { expect( its( :agency, :required_columns ).collect( &:name ) ).
      to eq required_names }
    it { expect( its( :agency, :optional_columns ).collect( &:name ) ).
      to eq optional_names }
    it { expect( its( :agency, :unique_columns ).collect( &:name ) ).
      to eq unique_names }
  end
end
