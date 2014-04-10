describe GtfsReader::FeedHandler do
  subject do
    GtfsReader::FeedHandler.new(callback) { |callback| name &callback }
  end
  let(:callback) { Proc.new { |v| collection << v } }
  let(:collection) { [] }
  let(:enumerator) { [:a, :b, :c].each }

  it { expect{ subject.handle_file :name, enumerator }.
      to change{ collection }.to eq [:a, :b, :c] }
end
