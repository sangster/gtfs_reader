module GtfsReader
  VERSION = '0.1.0'
end

require './lib/gtfs-reader/core.rb'
require './lib/gtfs-reader/configuration.rb'
require './lib/gtfs-reader/exceptions.rb'

require './lib/gtfs-reader/config/feed_format.rb'
require './lib/gtfs-reader/config/column.rb'
require './lib/gtfs-reader/config/file_format.rb'
require './lib/gtfs-reader/config/prefixed_column_setter.rb'

require './lib/gtfs-reader/config/defaults/gtfs_feed_format.rb'
