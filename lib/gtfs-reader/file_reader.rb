require 'csv'

module GtfsReader
  CSV_OPTIONS = { headers: true,
                  return_headers: true,
                  header_converters: :symbol }

  # Iterates over the rows in a single file using a provided definition.
  #@see #each
  class FileReader
    include Enumerable

    attr_reader :definition, :columns

    #@param data [IO,String] CSV data
    #@param definition [FileDefinition] describes the expected columns in this
    #  file
    def initialize(data, definition)
      @csv = CSV.new data, CSV_OPTIONS
      @definition = definition
      @index = 0
      @columns = validate_columns @csv.shift.headers
    end

    #@overload each(&blk)
    #  @yieldparam hash [Hash] a hash of columns to their values in this row
    #@overload each
    #  @return [Enumerator] an {::Enumerator} that iterates of the rows in the
    #    file
    #@see FileRow#to_hash
    def each
      return to_enum :each unless block_given?

      while row = shift
        yield row.to_hash
      end
    end

    #@return [FileRow,nil] the next row from the file, or +nil+ if the end of
    #  the file has been reached.
    def shift
      if row = @csv.shift
        FileRow.new(@index, row, @definition).tap { @index += 1 }
      end
    end

    private

    # Validate the list of headers in the given file against the expected
    # columns in the definition
    def validate_columns(headers)
      @definition.required_columns.collect( &:name ).each do |col|
        raise RequiredHeaderMissing, col.to_s unless headers.include? col
      end

      cols = @definition.columns.collect &:name
      headers = headers.select {|h| cols.include? h }

      Hash[ *headers.inject([]) {|list,c| list << c << @definition[c] } ]
    end
  end

  # Contains the contents of a single row read in from the file 
  class FileRow
    attr_reader :line_number

    #@param line_number [Integer] the line number from the source file
    #@param row [CSV::Row] the data
    #@param definition [FileDefinition] the definition of the columns that the
    #  data in this row represent
    def initialize(line_number, row, definition)
      @line_number, @row, @definition = line_number, row, definition
      @parsed = {}
    end

    #@return [Array<Symbol>]
    def headers
      @row.headers
    end

    #@param column [Symbol] the name of the column to fetch
    #@return the parsed data for the column at this row
    #@see #raw
    def [](column)
      @parsed[column] ||= begin
        @context ||= HashContext.new(@row.to_hash)
        @context.instance_exec raw(column), &@definition[column].parser
      end
    end

    #@param (see #[])
    #@return the data unparsed data from the column at this row
    def raw(column)
      @row[column]
    end

    #@return [Hash] a hash representing this row of data, where each key is the
    #  column name and each value is the parsed data for this row
    def to_hash
      Hash[ *headers.inject([]) {|list,h| list << h << self[h] } ]
    end
  end
end
