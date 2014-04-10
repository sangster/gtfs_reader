describe GtfsReader::Configuration do
  subject(:cfg) { GtfsReader::Configuration.new }

  context 'with parameter test_value' do
    before { cfg.parameter :test_value }

    it { expect{ cfg.test_value 'test' }.to change{ its :test_value }.from(nil).to 'test' }
  end

  context 'with block-parameter section' do
    before { cfg.block_parameter :section, obj_class }

    let :obj do 
      double.tap { |obj| allow(obj).to receive(:test_method) }
    end

    let :obj_class do
      double.tap { |cl| allow(cl).to receive(:new).and_return obj }
    end

    it { expect( cfg.section {} ).not_to be_nil }
    it { expect( cfg.section ).not_to be_nil }
    it do
      cfg.section { test_method 'test' }
      expect( obj ).to have_received( :test_method ).with 'test'
    end
  end
end
