require 'csv'

module GtfsReader
  # Contains the contents of a single row read in from the file
  class FileRow
    attr_reader :line_number, :headers

    # @param line_number [Integer] the line number from the source file
    # @return [Array<Symbol>]
    # @param data [CSV::Row] the data for this row
    # @param definition [FileDefinition] the definition of the columns that the
    #   data in this row represent
    def initialize(line_number, headers, data, definition, do_parse)
      @line_number = line_number
      @headers = headers
      @data = data
      @definition = definition
      @do_parse = do_parse
      @parsed = {}
    end

    # @param column [Symbol] the name of the column to fetch
    # @return the parsed data for the column at this row
    # @see #raw
    def [](column)
      return raw(column) unless @do_parse

      @parsed[column] ||=
        ParserContext.new(column, self)
                     .instance_exec(raw(column), &@definition[column].parser)
    end

    # @return [Boolean] if this row has the given column
    def col?(col)
      @headers.include?(col)
    end

    # @param (see #[])
    # @return the data unparsed data from the column at this row
    def raw(column)
      @data[column]
    end

    # @return [Hash] a hash representing this row of data, where each key is the
    #   column name and each value is the parsed data for this row
    def to_hash
      ::Hash[
        *headers.inject([]) { |list, h| list << h << self[h] }
      ]
    end

    # @return [Array] an array representing this row of data
    def to_a
      headers.map { |h| self[h] }
    end
  end

  class ParserContext
    def initialize(column, file_row)
      @column = column
      @file_row = file_row
    end

    def method_missing(column)
      raise "Parser for '#{column}' cannot refer to itself" if column == @column

      @file_row.col?(column) ? @file_row[column] : super
    end

    def respond_to_missing?(_name, _include_private = false)
      true
    end
  end
end
