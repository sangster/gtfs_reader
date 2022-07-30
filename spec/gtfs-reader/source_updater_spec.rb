# frozen_string_literal: true

describe GtfsReader::SourceUpdater do
  let(:definition) do
    double('definition', url: 'spec/data/gtfs-with-utf8.zip')
  end

  describe :donwload_source do
    subject { GtfsReader::SourceUpdater.new 'foo', definition }

    context 'without internal encoding (Ruby default)' do
      before do
        @old_verbose = $VERBOSE
        $VERBOSE = nil
        @old_encoding = Encoding.default_internal
        Encoding.default_internal = 'UTF-8'
      end

      after do
        Encoding.default_internal = @old_encoding
        $VERBOSE = @old_verbose
      end

      it { expect { subject.download_source }.to_not raise_error }
    end
  end
end
