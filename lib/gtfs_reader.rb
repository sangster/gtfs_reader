module GtfsReader
  VERSION = '0.1.1'
end

require './lib/gtfs_reader/core.rb'
require './lib/gtfs_reader/configuration.rb'
require './lib/gtfs_reader/exceptions.rb'
require './lib/gtfs_reader/file_reader.rb'
require './lib/gtfs_reader/util.rb'

require './lib/gtfs_reader/config/feed_definition.rb'
require './lib/gtfs_reader/config/column.rb'
require './lib/gtfs_reader/config/file_definition.rb'
require './lib/gtfs_reader/config/prefixed_column_setter.rb'

require './lib/gtfs_reader/config/defaults/gtfs_feed_definition.rb'
