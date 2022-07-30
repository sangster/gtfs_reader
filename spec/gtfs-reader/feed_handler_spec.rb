# frozen_string_literal: true

describe GtfsReader::FeedHandler do
  subject do
    GtfsReader::FeedHandler.new(callback) { |callback| name(&callback) }
  end
  let(:callback) { proc { |v| collection << v } }
  let(:collection) { [] }
  let(:enumerator) { %i[a b c].each }

  it {
    expect { subject.handle_file :name, enumerator }
      .to change { collection }.to eq %i[a b c]
  }
end
