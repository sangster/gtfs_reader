require 'csv'

module GtfsReader
  # Contains the contents of a single row read in from the file
  class FileRow
    attr_reader :line_number

    #@param line_number [Integer] the line number from the source file
    #@return [Array<Symbol>]
    #@param data [CSV::Row] the data for this row
    #@param definition [FileDefinition] the definition of the columns that the
    #  data in this row represent
    def initialize(line_number, headers, data, definition, do_parse)
      @line_number, @headers, @data, @definition, @do_parse =
          line_number, headers, data, definition, do_parse
      @parsed = {}
    end

    #@return [Array<Symbol>]
    def headers
      @headers
    end

    #@param column [Symbol] the name of the column to fetch
    #@return the parsed data for the column at this row
    #@see #raw
    def [](column)
      return raw(column) unless @do_parse

      @parsed[column] ||= begin
        ParserContext.new(column, self).
            instance_exec raw(column), &@definition[column].parser
      end
    end

    #@param (see #[])
    #@return the data unparsed data from the column at this row
    def raw(column)
      @data[column]
    end

    #@return [Hash] a hash representing this row of data, where each key is the
    #  column name and each value is the parsed data for this row
    def to_hash
      ::Hash[ *headers.inject([]) {|list,h| list << h << self[h] } ]
    end

    #@return [Array] an array representing this row of data
    def to_a
      headers.map {|h| self[h] }
    end
  end

  class ParserContext
    def initialize(column, file_row)
      @column, @file_row = column, file_row
    end

    def method_missing(column)
      if column == @column
        raise "Parser for '#{column}' cannot refer to itself"
      end
      @file_row[column] or super
    end
  end
end
