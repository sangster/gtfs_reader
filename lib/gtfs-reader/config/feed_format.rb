module GtfsReader::Config
  # Describes a GTFS feed and the {FileFormat files} it is expected to provide.
  class FeedFormat
    def initialize
      @_file_formats = {}
    end

    #@return [Array<FileFormat>] All of the defined files.
    def files
      @_file_formats.values
    end

    # This class uses +method_missing+ to generate file definitions.
    # @return [true]
    def respond_to?(sym)
      true
    end

    #@overload method_missing(name, *args, &blk)
    #  Defines a new file in the feed.
    #
    #  @param name [String] the name of this file within the feed. This name
    #    should not include a file extension (like +.txt+)
    #  @param args [Array] the first argument is used as a +Hash+ of options to
    #    create the new file definition
    #  @param blk [Proc] this block is +instance_eval+ed on the new {FileFormat
    #    file}
    #  @return [FileFormat] the newly created file
    #
    #@overload method_missing(name)
    #  @param name [String] the name of the file to return
    #  @return [FileFormat] the previously created file with the given name
    #@see FileFormat
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
