# GTFS Reader

```ruby
gem 'gtfs-reader'
```

GTFS Reader is a gem designed to help process the contents of a "[GTFS
Feed](https://developers.google.com/transit/gtfs)":

> The General Transit Feed Specification (GTFS) defines a common format for
> public transportation schedules and associated geographic information. GTFS
> "feeds" allow public transit agencies to publish their transit data and
> developers to write applications that consume that data in an interoperable
> way.

Essentially, a GTFS feed is a ZIP file containing 
[CSV-formatted](https://en.wikipedia.org/wiki/Comma-separated_values) .txt
files which following the specification.

## Usage

## Simple Example

```ruby
require 'gtfs_reader'

GtfsReader.config do
  return_hashes true
  # verbose true #uncomment for verbose output
  sources do
    sample do
      url 'http://localhost/sample-feed.zip' # you can also use a filepath here 
      before { |etag| puts "Processing source with tag #{etag}..." }
      handlers do
        agency {|row| puts "Read Agency: #{row[:agency_name]}" }
        routes {|row| puts "Read Route: #{row[:route_long_name]}" }
      end
    end
  end
end

GtfsReader.update :sample # or GtfsReader.update_all!
```

Assuming that `http://localhost/sample-feed.zip` returns the [Example Feed]
(https://developers.google.com/transit/gtfs/examples/gtfs-feed), this script
will print the following:

```
Processing source with tag 4d9d3040c284f0581cd5620d5c131109...
Read Agency: Demo Transit Authority
Read Route: Airport - Bullfrog
Read Route: Bullfrog - Furnace Creek Resort
Read Route: Stagecoach - Airport Shuttle
Read Route: City
Read Route: Airport - Amargosa Valley
```
