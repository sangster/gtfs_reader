module GtfsReader
  class BulkFeedHandler
    def initialize(bulk_size, args=[], &block)
      @bulk_size = bulk_size
      @callbacks = {}
      BulkFeedHandlerDsl.new(self).instance_exec *args, &block
    end

    def handler?(filename)
      @callbacks.key? filename
    end

    def handle_file(filename, reader)
      unless @callbacks.key? filename
        Log.warn { "No handler registered for #{filename.to_s.red}.txt" }
        return
      end

      calls = callbacks filename
      calls[:before].call if calls.key? :before
      read_row = calls[:read]

      values = []
      total = bulk_count = 0
      cols = reader.col_names
      reader.each do |row|
        values << (read_row ? read_row.call(row) : row)
        bulk_count += 1

        if bulk_count == @bulk_size
          total += bulk_count
          calls[:bulk].call values, bulk_count, total, cols
          bulk_count = 0
          values = []
        end
      end

      unless bulk_count == 0
        calls[:bulk].call values, bulk_count, (total + bulk_count), cols
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
      BulkDsl.new(@feed_handler, filename).instance_exec &block

      unless @feed_handler.callback? :bulk, filename
        raise HandlerMissingError, "No bulk block for #{filename}"
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
