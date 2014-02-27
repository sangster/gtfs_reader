require 'spec_helper'

describe GtfsReader do
  context '#config' do
    it { expect( GtfsReader.config ).to be_a GtfsReader::Configuration }
    it { expect{ |b| GtfsReader.config( &b ) }.to yield_with_args GtfsReader::Configuration }

    context 'config called twice' do
      before do
        GtfsReader.config { archive_format.table {} }
      end

      it { expect( GtfsReader.config.archive_format.table ).not_to be_nil }
      it do
        expect{ GtfsReader.config { parameter :new_param } }.not_to change {
          GtfsReader.config.archive_format.table
        }
      end
    end
  end
end
