# frozen_string_literal: true

require 'gtfs_reader/file_reader'

describe GtfsReader::FileReader do
  let(:definition) do
    GtfsReader::Config::FileDefinition.new('test_file').tap do |file_def|
      file_def.instance_eval(&columns)
    end
  end

  let :columns do
    proc do
      col :ha, &output_map({ one: '1', two: '2' }, :default)
      col :hb, required: true
    end
  end
  let(:data) { "ha,hb\n1a,1b" }

  describe :new do
    subject { GtfsReader::FileReader }

    context 'with a required column' do
      #   context 'with good data' do
      #     let( :data ) { "ha,hb\n1a,1b" }
      #     it { expect{ subject.new data, definition }.not_to raise_exception }
      #   end

      context 'with bad data' do
        let(:data) { "ha,bad_col\n1a,1b" }

        it {
          expect { subject.new data, definition, validate: true }
            .to raise_exception GtfsReader::RequiredColumnsMissing
        }
      end
    end
  end

  describe :columns do
    subject(:reader) { GtfsReader::FileReader.new data, definition }
    it { expect(its(:columns, :keys)).to eq %i[ha hb] }
    it { expect(its(:columns)[:hb]).to be_required }
  end

  describe :parsing do
    subject(:reader) { GtfsReader::FileReader.new data.join("\n"), definition }
    let(:data) { %w[ha,hb 1,1 2,2 3,3 4,4] }
    let(:expected) do
      [
        { ha: :one, hb: '1' },
        { ha: :two, hb: '2' },
        { ha: :default, hb: '3' },
        { ha: :default, hb: '4' }
      ]
    end

    it { expect(reader.to_a).to eq expected }

    context 'parser with column reference' do
      let :columns do
        proc do
          col(:ha) { |i| hb.to_i.even? ? :even : (i.to_i * 10) }
          col :hb, required: true
        end
      end

      let(:expected) do
        [{ ha: 10, hb: '1' }, { ha: :even, hb: '2' },
         { ha: 30, hb: '3' }, { ha: :even, hb: '4' }]
      end

      it { expect(reader.to_a).to eq expected }
    end

    context 'with no rows' do
      let(:data) { %w[ha,hb] }

      it { expect(reader.shift).to be_nil }
    end

    context 'with one row' do
      let(:data) { %w[ha,hb 1,1] }

      it { expect(reader.instance_exec { shift && shift }).to be_nil }
    end
  end
end
