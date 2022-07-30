# frozen_string_literal: true

require 'gtfs_reader/version'

describe GtfsReader::Version do
  subject { GtfsReader::Version }
  it { expect(subject::MAJOR).to be_an Integer }
  it { expect(subject::MINOR).to be_an Integer }
  it { expect(subject::PATCH).to be_an Integer }
  it {
    expect(subject::BUILD.class).to(
      satisfy { |klass| [String, NilClass].include?(klass) }
    )
  }

  it { expect(subject.to_s).to match(/^\d+\.\d+\.\d+(\.[\w]+)?$/) }
end
