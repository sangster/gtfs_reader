require_relative 'file_definition'

module GtfsReader
  module Config
    # Describes a GTFS feed and the {FileDefinition files} it is expected to
    # provide.
    class FeedDefinition
      def initialize
        @file_definition = {}
      end

      #@return [Array<FileDefinition>] All of the defined files.
      def files
        @file_definition.values
      end

      def required_files
        files.select &:required?
      end

      def optional_files
        files.reject &:required?
      end
      
      # @param name[Symbol] name of the file 
      # @return[FileDefinition] 
      def file(name)
        self.files.each do |fd|
          return fd if fd.name == name
        end
      end
      #@overload file(name, *args, &block)
      #  Defines a new file in the feed.
      #
      #  @param name [String] the name of this file within the feed. This name
      #    should not include a file extension (like +.txt+)
      #  @param args [Array] the first argument is used as a +Hash+ of options
      #    to create the new file definition
      #  @param block [Proc] this block is +instance_eval+ed on the new
      #    {FileDefinition file}
      #  @return [FileDefinition] the newly created file
      #
      #@overload file(name)
      #  @param name [String] the name of the file to return
      #  @return [FileDefinition] the previously created file with the given name
      #@see FileDefinition
      def file(name, *args, &block)
        return @file_definition[name] unless block_given?

        definition_for!( name, args.first ).tap do |d|
          d.instance_exec &block if block
        end
      end
      private
        def definition_for!(name, opts)
          @file_definition[name] ||= FileDefinition.new( name, opts )
        end
      
    end
  end
end
