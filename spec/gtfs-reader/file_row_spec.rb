# frozen_string_literal: true

describe GtfsReader::FileRow do
  subject { build :file_row, headers: headers, data: data, definition: definition }
  let(:headers) { build :file_row_headers }
  let(:data) { build :file_row_data }
  let(:definition) { build :file_row_definition }

  it { expect(its(:line_number)).to be_a Integer }
  it { expect(its(:headers)).to eq headers }
  it { expect(headers.map { |h| subject[h] }).to eq data.values }
  it { expect(its(:to_a)).to eq data.values }
  it { expect(its(:to_hash)).to eq data }

  context 'with a column parser' do
    let(:definition) do
      build(:file_row_definition).tap do |fd|
        fd.col :ha, &:to_sym
      end
    end

    it { expect(subject[:ha]).to be_a Symbol }
    it { expect(headers[1..-1].all? { |h| subject[h].is_a?(String) }).to be_truthy }
  end

  context 'with a definition with recursive column parsers' do
    let(:definition) do
      build(:file_row_definition).tap do |fd|
        fd.col(:ha) { ha }
      end
    end

    it { expect { subject[:ha] }.to raise_error(RuntimeError) }
  end
end
