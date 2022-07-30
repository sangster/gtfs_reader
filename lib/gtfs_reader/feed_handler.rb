# frozen_string_literal: true

module GtfsReader
  # This handler returns each row individually as it is read in from the source.
  class FeedHandler
    def initialize(args = [], &block)
      @read_callbacks = {}
      FeedHandlerDsl.new(self).instance_exec(*args, &block)
    end

    # @param filename [String] the name of the file to handle
    # @return [Boolean] if this handler can handle the given filename
    def handler?(filename)
      @read_callbacks.key?(filename)
    end

    def handle_file(filename, enumerator)
      enumerator.each(&@read_callbacks[filename])
    end

    def create_read_handler(filename, *_args, &block)
      @read_callbacks[filename] = block
    end
  end

  class FeedHandlerDsl
    def initialize(feed_handler)
      @feed_handler = feed_handler
    end

    def method_missing(filename, *args, &block)
      @feed_handler.create_read_handler(filename, *args, &block)
    end

    def respond_to_missing?(_name, _include_private = false)
      true
    end
  end
end
