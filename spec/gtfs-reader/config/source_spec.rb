# frozen_string_literal: true

describe GtfsReader::Config::Source do
  subject { build :source, name: }
  let(:name) { 'Source Name' }
  let(:default_definition) { GtfsReader::Config::Defaults::FEED_DEFINITION }
  let(:url) { 'http://example.com/feed.zip' }
  let(:path) { '/tmp/test.zip' }

  it { expect(its(:name)).to eq name }
  it { expect(its(:feed_definition)).to be default_definition }
  it { expect(its(:handlers)).to be_a GtfsReader::FeedHandler }

  describe '#before' do
    it do
      expect { subject.before { nil } }.to change { its :before }.from(nil).to be_a Proc
    end
  end

  describe 'feed_definition' do
    it { expect { subject.feed_definition { nil } }.to(change { its :feed_definition }) }
  end

  describe '#handlers' do
    context 'with a handler' do
      before { subject.handlers(:file) { nil } }
      it { expect(subject.handlers(:file)).to be_a GtfsReader::FeedHandler }
    end

    context 'with a bulk handler' do
      before { subject.handlers(:file, bulk: 1024) { nil } }
      it { expect(subject.handlers(:file)).to be_a GtfsReader::BulkFeedHandler }
    end
  end

  describe '#path' do
    it { expect { subject.path(path) }.to change { its :path }.from(nil).to path }

    context 'when a url has already been specified' do
      before { subject.url(url) }

      it do
        expect { subject.path(path) }.to raise_error GtfsReader::Config::SourceDefinitionError
      end
    end
  end

  describe '#url' do
    it { expect { subject.url(url) }.to change { its :url }.from(nil).to url }

    context 'when a path has already been specified' do
      before { subject.path(path) }

      it do
        expect { subject.url(url) }.to raise_error GtfsReader::Config::SourceDefinitionError
      end
    end
  end

  describe '#location' do
    context 'with a url' do
      before { subject.url(url) }

      it { expect(subject.location).to eq url }
    end

    context 'with a url' do
      before { subject.path(path) }

      it { expect(subject.location).to eq path }
    end
  end
end
