# frozen_string_literal: true

describe GtfsReader::Config::Source do
  subject { build :source, name: name }
  let(:name) { 'Source Name' }
  let(:default_definition) { GtfsReader::Config::Defaults::FEED_DEFINITION }
  let(:url) { 'http://example.com/feed.zip' }

  it { expect(its(:name)).to eq name }
  it { expect(its(:feed_definition)).to be default_definition }
  it { expect(its(:handlers)).to be_a GtfsReader::FeedHandler }

  it { expect { subject.url url }.to change { its :url }.from(nil).to url }
  it {
    expect { subject.before {} }.to change { its :before }
      .from(nil).to be_a Proc
  }
  it { expect { subject.feed_definition {} }.to(change { its :feed_definition }) }

  context 'with a handler' do
    before { subject.handlers(:file) {} }
    it { expect(subject.handlers(:file)).to be_a GtfsReader::FeedHandler }
  end

  context 'with a bulk handler' do
    before { subject.handlers(:file, bulk: 1024) {} }
    it { expect(subject.handlers(:file)).to be_a GtfsReader::BulkFeedHandler }
  end
end
