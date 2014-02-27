require 'spec_helper'

describe GtfsReader::Config::Column do
  subject(:column) { build :column, opts: opts }
  let(:opts) { {} }
  
  it { expect( column ).not_to be_required }
  it { expect( its :name ).not_to be_nil }
  it { expect( its :parser ).to be_a Proc }
  it { expect( column.parser.call 'input' ).to eq 'input' }

  context 'is required' do
    let(:opts) { {required: true} }
    it{ expect( column ).to be_required }
  end
end
