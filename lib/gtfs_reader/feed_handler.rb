module GtfsReader
  class FeedHandler
    def initialize(args=[], &block)
      @read_callbacks = {}
      FeedHandlerDsl.new(self).instance_exec *args, &block
    end

    def handle_file(filename, enumerator)
      Log.warn { "handle_file (#{filename})"}
      enumerator.each &@read_callbacks[filename]
    end

    def create_read_handler(filename, *args, &block)
      @read_callbacks[filename] = block
    end
  end

  class FeedHandlerDsl
    def initialize(feed_handler)
      @feed_handler = feed_handler
    end

    def method_missing(filename, *args, &block)
      @feed_handler.create_read_handler filename, *args, &block
    end
  end
end
