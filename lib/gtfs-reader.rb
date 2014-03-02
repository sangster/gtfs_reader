module GtfsReader
  VERSION = '0.1.0'
end

require './lib/gtfs-reader/core.rb'
require './lib/gtfs-reader/configuration.rb'
require './lib/gtfs-reader/exceptions.rb'
require './lib/gtfs-reader/file_reader.rb'
require './lib/gtfs-reader/util.rb'

require './lib/gtfs-reader/config/feed_definition.rb'
require './lib/gtfs-reader/config/column.rb'
require './lib/gtfs-reader/config/file_definition.rb'
require './lib/gtfs-reader/config/prefixed_column_setter.rb'

require './lib/gtfs-reader/config/defaults/gtfs_feed_definition.rb'
