require 'spec_helper.rb'

describe GtfsReader::Configuration do
  subject(:cfg) { GtfsReader::Configuration.new }

  context 'with parameter test_value' do
    before { cfg.parameter :test_value }

    it { expect{ cfg.test_value 'test' }.to change{ its :test_value }.from(nil).to 'test' }
  end

  context 'with block-paramter section' do
    before { cfg.block_parameter :section, obj_class }

    let :obj do 
      double.tap do |obj|
        allow( obj ).to receive( :test_method )
      end
    end

    let :obj_class do
      double.tap do |cl|
        allow( cl ).to receive( :new ).and_return obj
      end
    end

    it { expect( cfg.section {} ).not_to be_nil }
    it { expect( cfg.section ).not_to be_nil }
    it do
      cfg.config do
        section { test_method 'test' }
      end
      expect( obj ).to have_received( :test_method ).with 'test'
    end
  end
end
