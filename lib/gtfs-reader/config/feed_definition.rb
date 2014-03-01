module GtfsReader::Config
  # Describes a GTFS feed and the {FileDefinition files} it is expected to
  # provide.
  class FeedDefinition
    def initialize
      @_file_definition = {}
    end

    #@return [Array<FileDefinition>] All of the defined files.
    def files
      @_file_definition.values
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
    #  @param blk [Proc] this block is +instance_eval+ed on the new {FileDefinition
    #    file}
    #  @return [FileDefinition] the newly created file
    #
    #@overload method_missing(name)
    #  @param name [String] the name of the file to return
    #  @return [FileDefinition] the previously created file with the given name
    #@see FileDefinition
    def method_missing(name, *args, &blk)
      return @_file_definition[name] unless block_given?

      definition_for( name, args.first ).tap { |d| d.instance_eval &blk }
    end

    def to_s
      files.collect( &:to_s ).join ?\n
    end

    private

    def definition_for(name, opts)
      @_file_definition[name] ||= FileDefinition.new( name, opts )
    end
  end
end
