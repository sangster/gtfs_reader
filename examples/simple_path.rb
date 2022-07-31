# frozen_string_literal: true

# This example script loads a GTFS feed from a file on the local machine.
LOCAL_PATH = ARGV.first || '/tmp/sample-feed.zip'

require_relative '../lib/gtfs_reader'

GtfsReader.config do
  # verbose true # TODO: uncomment for verbose output
  return_hashes true

  sources do
    sample do
      path LOCAL_PATH
      before { |etag| puts "Processing source with tag #{etag}..." }
      handlers do
        agency { |row| puts "Read Agency: #{row[:agency_name]}" }
        routes { |row| puts "Read Route: #{row[:route_long_name]}" }
      end
    end
  end
end

GtfsReader.update(:sample)
