require_relative 'feed_definition'
require_relative 'defaults/gtfs_feed_definition'

module GtfsReader
  module Config
    # A single source of GTFS data
    class Source
      attr_reader :name

      def initialize(name)
        @name = name
        @feed_definition = Config::Defaults::FEED_DEFINITION
      end

      #@param u [String] if given, will be used as the URL for this source
      #@return [String] the URL this source's ZIP file
      def url(u=nil)
        @url = u if u.present?
        @url
      end

      def feed_definition(&block)
        if block_given?
          @feed_definition = FeedDefinition.new.tap do |feed|
            feed.instance_exec &block
          end
        end

        @feed_definition
      end

      def handlers(opts={}, &block)
        @handler_opts = opts.reverse_merge bulk: nil

        @handlers = block if block_given?
        @handlers
      end

      #@return [Boolean] are the rows of this source being handled in bulk
      def bulk?
        @handler_opts && @handler_opts[:bulk]
      end
    end
  end
end
