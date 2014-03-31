module GtfsReader
  class BulkFeedHandler
    def initialize(bulk_size, args=[], &block)
      @bulk_size = bulk_size
      @callbacks = {}
      BulkFeedHandlerDsl.new(self).instance_exec *args, &block
    end

    def handle_file(filename, enumerator)
      unless @callbacks.key? filename
        Log.warn { "No handler registered for #{filename.to_s.red}.txt" }
        return
      end

      calls = callbacks filename
      calls[:before].call if calls.key? :before

      models = []
      total = bulk_count = 0
      enumerator.each do |row|
        models << calls[:read].call(row)
        bulk_count += 1

        if bulk_count == @bulk_size
          total += bulk_count
          calls[:bulk].call models, bulk_count, total
          bulk_count = 0
          models = []
        end
      end

      unless bulk_count == 0
        calls[:bulk].call models, bulk_count, (total + bulk_count)
      end

      nil
    end

    def create_callback(kind, filename, block)
      Log.debug do
        kind_str = kind.to_s.center(:before.to_s.length).magenta
        "create callback (#{kind_str}) #{filename.to_s.red}"
      end
      callbacks(filename)[kind] = block
    end

    def callback?(kind, filename)
      @callbacks.key? filename and @callbacks[filename].key? kind
    end

    private

    def callbacks(filename)
      @callbacks[filename] ||= {}
    end
  end

  class BulkFeedHandlerDsl
    def initialize(feed_handler)
      @feed_handler = feed_handler
    end

    def method_missing(filename, *args, &block)
      if args.length != 0
        require 'pry'
        binding.pry
      end
      BulkDsl.new(@feed_handler, filename).instance_exec &block

      unless @feed_handler.callback? :read, filename
        raise SourceDefinitionError, "No read block for #{filename}"
      end

      unless @feed_handler.callback? :bulk, filename
        raise SourceDefinitionError, "No bulk block for #{filename}"
      end
    end
  end

  class BulkDsl
    def initialize(feed_handler, filename)
      @feed_handler, @filename = feed_handler, filename
    end

    def before(&block)
      @feed_handler.create_callback :before, @filename, block
    end

    def read(&block)
      @feed_handler.create_callback :read, @filename, block
    end

    def bulk(&block)
      @feed_handler.create_callback :bulk, @filename, block
    end
  end
end
