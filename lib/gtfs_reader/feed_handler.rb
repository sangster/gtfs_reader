module GtfsReader
  class FeedHandler
    def initialize(&block)
      @read_callbacks = {}
      FeedHandlerDsl.new(self).instance_exec &block
    end

    def handle_file(filename, enumerator)
      enumerator.each &@read_callbacks[filename]
    end

    def create_read_handler(filename, &block)
      @read_callbacks[filename] = block
    end
  end

  class FeedHandlerDsl
    def initialize(feed_handler)
      @feed_handler = feed_handler
    end

    def method_missing(filename, &block)
      @feed_handler.create_read_handler filename, &block
    end
  end
end
