# GTFS Reader

[![Build Status](https://travis-ci.org/sangster/gtfs_reader.svg?branch=master)](https://travis-ci.org/sangster/gtfs_reader)

```ruby
gem 'gtfs_reader'
```

GTFS Reader is a gem designed to help process the contents of a "[GTFS
Feed](https://developers.google.com/transit/gtfs)":

> The General Transit Feed Specification (GTFS) defines a common format for
> public transportation schedules and associated geographic information. GTFS
> "feeds" allow public transit agencies to publish their transit data and
> developers to write applications that consume that data in an interoperable
> way.

Essentially, a GTFS feed is a ZIP file containing
[CSV-formatted](https://en.wikipedia.org/wiki/Comma-separated_values) .txt files
following the specification.

## Usage

## Simple Example

```ruby
require 'gtfs_reader'

GtfsReader.config do
  # verbose true # Uncomment for verbose output
  return_hashes true

  sources do
    sample do
      # Note: 'url' and 'path' are mutually exclusive
      url 'http://localhost/sample-feed.zip' # Remote feed
      # path '/srv/gtfs/sample-feed.zip' # Locale feed

      before { |etag| puts "Processing source with tag #{etag}..." }
      handlers do
        agency { |row| puts "Read Agency: #{row[:agency_name]}" }
        routes { |row| puts "Read Route: #{row[:route_long_name]}" }
      end
    end
  end
end

GtfsReader.update(:sample) # or GtfsReader.update_all!
```

Assuming that `http://localhost/sample-feed.zip` returns the
[Example Feed](https://developers.google.com/transit/gtfs/examples/gtfs-feed),
this script will print the following:

```
Processing source with tag 4d9d3040c284f0581cd5620d5c131109...
Read Agency: Demo Transit Authority
Read Route: Airport - Bullfrog
Read Route: Bullfrog - Furnace Creek Resort
Read Route: Stagecoach - Airport Shuttle
Read Route: City
Read Route: Airport - Amargosa Valley
```

## Custom Feed Format

By default, this gem parses files in the format specified by the [GTFS Feed
Spec](https://developers.google.com/transit/gtfs/reference). You can see this
`FeedDefinition` in [config/defaults/gtfs_feed_definition.rb](https://github.com/sangster/gtfs_reader/blob/develop/lib/gtfs_reader/config/defaults/gtfs_feed_definition.rb).
However, in many cases these feeds are created by people who aren't
technically-proficient and may not exactly conform to the spec. In the event
that you want to parse a file with a different format, you can do so in the
`GtfsReader.config` block:

```ruby
GtfsReader.config do
  sources do
    sample do
      feed_definition do
        file(:drivers, required: true) do # for my_file.txt
          col(:licence_number, required: true, unique: true)

          # If the employment column contains "1", the symbol :fulltime will be
          # returned, or "2" for :temporary; otherwise :unspecified will be returned

          col :employment, &output_map({ fulltime: '1', temporary: '2' }, :unspecified)

          # This will allow you to create a custom parser. Within the given
          # block you can reference other columns in the current row by name.
          col :name do |name|
            case employment
            when :fulltime  then "Mr. #{name}"
            when :temporary then "#{name} the newbie"
            else name
            end
          end
        end
      end

      # ...

    end
  end
end
```
