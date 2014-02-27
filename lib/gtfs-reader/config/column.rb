module GtfsReader::Config
  # Defines a single column in a {FileFormat file}.
  class Column
    # A "parser" which simply returns its input. Used by default
    IDENTITY_PARSER = ->(arg) { arg }

    attr_reader :name, :parser

    #@param name [String] the name of the column
    #@option opts [Boolean] :required (false) If this column is required to
    #  appear in the given file
    #@option opts [String] :alias an alternative name for this column. Many
    #  column names are needlessly prefixed with their filename:
    #  +Stop.stop_name+ could be aliased to +Stop.name+ for example.
    #@option opts [Boolean] :unique (false) if values in this column need to be
    #  unique among all rows in the file.
    def initialize(name, opts={}, &parser)
      @name = name
      @parser = block_given? ? parser : IDENTITY_PARSER

      @opts = { 
        required: false, 
        alias: nil,
        unique: false
      }.merge (opts || {})
    end

    #@return [Boolean] if this column is required to appear in the file
    def required?
      @opts[:required]
    end

    #@return [Boolean] if values in this column need to be unique among all rows
    #  in the file.
    def unique?
      @opts[:unique]
    end

    #@return [String,nil] this column's name's alias, if there is one
    def alias
      @opts[:alias]
    end
  end
end
