describe GtfsReader::Config::FeedDefinition do
  subject(:feed) do
    GtfsReader::Config::FeedDefinition.new.tap do |feed|
      feed.instance_exec(&definition)
    end
  end

  let :definition do
    Proc.new do
      file(:routes) { col :col_1; col :col_2, required: true }
      file(:trips)  { col :col_1; col :col_2, optional: true }
    end
  end

  it { expect( subject.file :undefined_table ).to be_nil }
  #it { expect{ feed.new_table {} }.to change { its :new_table }.from nil }
  it { expect( feed.required_files.map(&:name) ).to be_empty }
  it { expect( feed.optional_files.map(&:name) ).to eq [:routes, :trips] }

  context 'with a file defined' do
    let(:definition) do
      Proc.new do
        file :agency, required: true do
          col :agency_name,     required: true
          col :agency_url,      required: true
          col :agency_timezone, required: true
          col :agency_id,                       unique: true
          col :agency_lang
          col :agency_phone
          col :agency_fare_url
        end
      end
    end

    let(:required_names) { %i{agency_name agency_url agency_timezone} }
    let(:optional_names) { %i{agency_id agency_lang agency_phone agency_fare_url} }
    let(:unique_names) { %i{agency_id} }

    it { expect( feed.required_files.map(&:name) ).to eq [:agency] }
    it { expect( feed.optional_files.map(&:name) ).to be_empty }

    it { expect( feed.file(:agency).col :id ).to be feed.file(:agency).col :id }
    it { expect( feed.files.collect(&:name) ).to eq [:agency] }

    it { expect( feed.file(:agency).required_columns.collect( &:name ) ).
      to eq required_names }
    it { expect( feed.file(:agency).optional_columns.collect( &:name ) ).
      to eq optional_names }
    it { expect( feed.file(:agency).unique_columns.collect( &:name ) ).
      to eq unique_names }
  end
end
