require_relative 'column'
require_relative 'prefixed_column_setter'

module GtfsReader
  module Config
    # Describes a single file in a {FeedDefinition GTFS feed}.
    class FileDefinition
      attr_reader :name

      #@param name [String] The name of the file within the feed.
      #@option opts [Boolean] :required (false)
      #  If this file is required to be in the feed.
      def initialize(name, opts={})
        @name, @columns = name, {}
        @opts = { required: false }.merge (opts || {})
        @aliases = {}
      end
      
      #@return [Hash] List of aliases. In the form :alias => :column
      def aliases
        @aliases
      end
      
      #@return [Boolean] If this file is required to be in the feed.
      def required?
        @opts[:required]
      end

      #@return [String] The filename of this file within the GTFS feed.
      def filename
        "#{name}.txt"
      end

      #@return [Column] The column with the given name
      def [](name)
        @columns[name]
      end

      def columns
        @columns.values
      end

      #@return [Array<Column>] The columns required to appear in this file.
      def required_columns
        columns.select &:required?
      end

      #@return [Array<Column>] The columns not required to appear in this file.
      def optional_columns
        columns.reject &:required?
      end

      #@return [Array<Column>] The columns which cannot have two rows with the
      #  same value.
      def unique_columns
        columns.select &:unique?
      end

      # Creates a column with the given name.
      #
      #@param name [String] The name of the column to define.
      #@param args [Array] The first element of this args list is used as a
      #  +Hash+ of options to create the new column with.
      #@param block [Proc] An optional block used to parse the values of this
      #  column on each row.
      #@yieldparam input [String] The value of this column for a particular row.
      #@yieldreturn Any kind of object.
      #@return [Column] The newly created column.
      def col(name, *args, &block)
        name = @aliases[name] if @aliases.key? name

        if @columns.key? name
          @columns[name].parser &block if block_given?
          return @columns[name]
        end

        (@columns[name] = Column.new name, args.first, &block).tap do |col|
          @aliases[col.alias] = name if col.alias
        end
      end

      # Starts a new block within which any defined columns will have the given
      # +sym+ prefixed to its name (joined with an underscore). Also, the
      # defined name given within the block will be aliased to the column.
      #@param sym the prefix to prefixed to each column within the block
      #
      #@example Create a column +route_name+ with the alias +name+
      #  prefix( :route ) { name }
      def prefix(sym, &blk)
        PrefixedColumnSetter.new(self, sym.to_s).instance_exec &blk
      end

      # Creates an input-output proc to convert column values from one form to
      # another.
      #
      # Many parser procs simply map a set of known values to another set of
      # known values. This helper creates such a proc from a given hash and
      # optional default.
      #
      #@param default [] The value to return if there is no mapping for a given
      #  input.
      #@param reverse_map [Hash] A map of returns values to their input values.
      #  This is in reverse because it looks better, like a list of labels:
      #  +{bus: 3, ferry: 4}+
      def output_map(default=nil, reverse_map)
        if reverse_map.values.uniq.length != reverse_map.values.length
          raise FileDefinitionError, "Duplicate values given: #{reverse_map}"
        end

        map = default.nil? ? {} : Hash.new( default )
        reverse_map.each { |k,v| map[v] = k }
        map.method( :[] ).to_proc
      end
    end
  end
end
