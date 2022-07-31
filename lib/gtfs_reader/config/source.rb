# frozen_string_literal: true

require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/object/try'

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
        @feed_handler = FeedHandler.new { nil }
        @url = nil
        @before = nil
      end

      # @param title [String] if given, will be used as the title of this source
      # @return [String] the title of this source
      def title(title = nil)
        @title = title if title.present?
        @title
      end

      # @param url [String] if given, will be used as the URL for this source
      # @return [String] the URL this source's ZIP file
      def url(url = nil)
        @url = url if url.present?
        @url
      end

      # Define a block to call before the source is read. If this block
      # returns +false+, cancel processing the source
      def before(&block)
        @before = block if block_given?
        @before
      end

      def feed_definition(&)
        if block_given?
          @feed_definition = FeedDefinition.new.tap do |feed|
            feed.instance_exec(feed, &)
          end
        end

        @feed_definition
      end

      def handlers(*args, &)
        if block_given?
          opts = args.last.try(:is_a?, Hash) ? args.pop : {}
          opts = opts.reverse_merge(bulk: nil)
          @feed_handler =
            if opts[:bulk]
              BulkFeedHandler.new(opts[:bulk], args, &)
            else
              FeedHandler.new(args, &)
            end
        end

        @feed_handler
      end
    end
  end
end
