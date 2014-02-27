require 'spec_helper'

describe GtfsReader::Config do
  subject(:format) { build :file_format }
  
  context '#new' do
    it { expect( its :name ).not_to be_nil }
    it { expect{ format.name = "bob" }.to change{ format.name }.to eq "bob" }
    it { expect{ format.name = "bob" }.to change{ format.filename }.to eq "bob.txt" }
    it { expect( its :required ).to be_empty }
    it { expect( its :optional ).to be_empty }
  end

  it { expect{ format.optional :a, :b }.to change{ format.optional }.to eq [:a, :b] }
  it { expect{ format.required :a, :b }.to change{ format.required }.to eq [:a, :b] }

  it { expect{ format.required :same, :same }.to change{ format.required }.to eq [:same] }
  it { expect{ format.optional :same, :same }.to change{ format.optional }.to eq [:same] }
end
