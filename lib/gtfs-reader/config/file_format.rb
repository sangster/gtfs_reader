module GtfsReader::Config
  # Describes a single file in a {FeedFormat GTFS feed}.
  class FileFormat
    # The name of the file within the feed.
    attr_reader :_name

    #@param name [String] The name of the file within the feed.
    #@option opts [Boolean] :required (false)
    #  If this file is required to be in the feed.
    def initialize(name, opts={})
      @_name, @_cols = name, {}
      @opts = { required: false }.merge (opts || {})
    end

    #@return [Boolean] If this file is required to be in the feed.
    def required?
      @opts[:required]
    end

    #@return [String] The filename of this file within the GTFS feed.
    def _filename
      "#{_name}.txt"
    end

    def columns
      @_cols.values
    end

    #@return [Array<Column>] The columns required to appear in this file.
    def required_cols
      columns.select &:required?
    end

    #@return [Array<Column>] The columns not required to appear in this file.
    def optional_cols
      columns.reject &:required?
    end

    #@return [Array<Column>] The columns which cannot have two rows with the
    #  same value.
    def unique_cols
      columns.select &:unique?
    end

    #@return [Boolean] +true+ for any method that does not begin with an
    #  underscore. This class uses +method_missing+ to specify this file's
    #  column names. Columns can be created with any name that does not begin
    #  with an underscore.
    def respond_to?(sym)
      sym.to_s[0] != '_' or super
    end

    # Creates a column with the given name.
    #
    #@param name [String] The name of the column to define.
    #@param args [Array] The first element of this args list is used as a +Hash+
    #  of options to create the new column with.
    #@param blk [Proc] An optional block used to parse the values of this column
    #  on each row.
    #@yieldparam input [String] The value of this column for a particular row.
    #@yieldreturn Any kind of object.
    def method_missing(name, *args, &blk)
      col = (@_cols[name] = Column.new name, args.first, &blk)

      define_singleton_method( col.name ) { |*_| col }
      define_singleton_method( col.alias ) { |*_| col } if col.alias
    end

    # Starts a new block within which any defined columns will have the given 
    # +sym+ prefixed to its name (joined with an underscore). Also, the defined
    # name given withen the block will be aliased to the column.
    #@param sym the prefix to prefixed to each column within the block
    #
    #@example Create a column +route_name+ with the alias +name+
    #  prefix( :route ) { name }
    def prefix(sym, &blk)
      PrefixedColumnSetter.new(self, sym.to_s).instance_eval &blk
    end

    # Creates an input-output proc to convert column values from one form to
    # another.
    #
    # Many parser procs simply map a set of known values to another set of
    # known values. This helper creates such a proc from a given hash and
    # optional default.
    #
    #@param default The value to return if there is no mapping for a given
    #  input.
    #@param reverse_map [Hash] A map of returns values to their input values.
    #  This is in reverse because it looks better, like a list of labels: +{bus:
    #  3, ferry: 4}+
    def output_map(default=nil, reverse_map)
      if reverse_map.values.uniq.length != reverse_map.values.length
        raise FileFormatError, "Duplicate values given: #{reverse_map}"
      end

      map = default.nil? ? {} : Hash.new( default )
      reverse_map.each { |k,v| map[v] = k }
      map.method( :[] ).to_proc
    end

    def to_s
      "#{_name}: " + columns.collect(&:to_s).join( ' ' )
    end
  end
end
