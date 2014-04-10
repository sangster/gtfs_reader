require 'active_support/core_ext/hash/reverse_merge'

require_relative 'feed_definition'
require_relative 'defaults/gtfs_feed_definition'
require_relative '../feed_handler'
require_relative '../bulk_feed_handler'

module GtfsReader
  module Config
    # A single source of GTFS data
    class Source
      attr_reader :name

      def initialize(name)
        @name = name
        @feed_definition = Config::Defaults::FEED_DEFINITION
        @feed_handler = FeedHandler.new {}
      end

      #@param u [String] if given, will be used as the URL for this source
      #@return [String] the URL this source's ZIP file
      def url(u=nil)
        @url = u if u.present?
        @url
      end

      # Define a block to call before the source is read. If this block
      # returns +false+, cancel processing the source
      def before(&block)
        if block_given?
          @before = block
        end
        @before
      end

      def feed_definition(&block)
        if block_given?
          @feed_definition = FeedDefinition.new.tap do |feed|
            feed.instance_exec feed, &block
          end
        end

        @feed_definition
      end

      def handlers(*args, &block)
        if block_given?
          opts = Hash === args.last ? args.pop : {}
          opts = opts.reverse_merge bulk: nil
          @feed_handler =
            if opts[:bulk]
              BulkFeedHandler.new opts[:bulk], args, &block
            else
              FeedHandler.new args, &block
            end
        end
        @feed_handler
      end
    end
  end
end
