# frozen_string_literal: true

describe GtfsReader::Config::Sources do
  subject { GtfsReader::Config::Sources.new }

  it {
    expect { subject.city }.to change { subject[:city] }.from(nil)
                                                        .to be_a GtfsReader::Config::Source
  }
end
