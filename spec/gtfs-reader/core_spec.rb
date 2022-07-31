# frozen_string_literal: true

describe GtfsReader do
  context '#config' do
    it { expect(GtfsReader.config).to be_a GtfsReader::Configuration }

    it do
      expect { |b| GtfsReader.config(&b) }
        .to yield_with_args GtfsReader::Configuration
    end

    context 'config called twice' do
      before do
        GtfsReader.config { feed_definition.file(:table) { nil } }
      end

      it { expect(GtfsReader.config.feed_definition.file(:table)).not_to be_nil }
      it do
        expect { GtfsReader.config { parameter :new_param } }
          .not_to(change { GtfsReader.config.feed_definition.file(:table) })
      end
    end

    context 'arguments given without a block' do
      it do
        expect { GtfsReader.config 'arg' }.to raise_exception(
          'arguments given without a block'
        )
      end
    end
  end
end
