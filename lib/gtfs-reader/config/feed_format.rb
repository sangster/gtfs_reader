module GtfsReader::Config
  class FeedFormat
    def initialize
      @_file_formats = {}
    end

    def files
      @_file_formats.values
    end

    def respond_to?(sym)
      true
    end

    def method_missing(name, *args, &blk)
      return @_file_formats[name] unless block_given?

      format_for( name, args.first ).tap do |format|
        format.instance_eval &blk
      end
    end

    private

    def format_for(name, opts)
      @_file_formats[name] ||= FileFormat.new( name, opts )
    end
  end
end
