module GtfsReader
  require_relative 'gtfs_reader/file_reader'
  require_relative 'gtfs_reader/version'
  require_relative 'gtfs_reader/configuration'
  require_relative 'gtfs_reader/hash_context'
  require_relative 'gtfs_reader/exceptions'

  module Config
    require_relative 'gtfs_reader/config/column'
    require_relative 'gtfs_reader/config/feed_definition'
    require_relative 'gtfs_reader/config/file_definition'
    require_relative 'gtfs_reader/config/prefixed_column_setter'

    module Defaults
    end
  end
end

require_relative 'gtfs_reader/core'
require_relative 'gtfs_reader/config/defaults/gtfs_feed_definition'
