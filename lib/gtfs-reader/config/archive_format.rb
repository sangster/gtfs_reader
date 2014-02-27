module GtfsReader::Config
  class ArchiveFormat
    def initialize
      @_file_formats = {}
    end

    def respond_to?(sym)
      true
    end

    def method_missing(name, &blk)
      return @_file_formats[name] unless block_given?

      (@_file_formats[name] ||= FileFormat.new( name )).tap do |format|
        format.instance_eval &blk
      end
    end
  end
end
