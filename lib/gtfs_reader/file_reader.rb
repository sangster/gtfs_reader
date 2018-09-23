require 'active_support/core_ext/object/blank'
require 'csv'
require_relative 'file_row'

module GtfsReader
  CSV_OPTIONS = { headers: :first_row,
                  return_headers: true,
                  header_converters: :symbol }.freeze

  # Iterates over the rows in a single file using a provided definition.
  # @see #each
  class FileReader
    include Enumerable

    attr_reader :definition, :columns, :col_names

    # @param data [IO,String] CSV data
    # @param definition [FileDefinition] describes the expected columns in this
    #   file
    def initialize(data, definition, opts = {})
      opts = { parse: true, validate: false, hash: true }.merge(opts)

      @csv = CSV.new(data, CSV_OPTIONS)
      @definition = definition
      @do_parse = opts[:parse]
      @return_hash = opts[:hash]
      @index = 0
      @csv_headers = @csv.shift.headers
      @columns = find_columns(opts[:validate])
    end

    def filename
      @definition.filename
    end

    # @overload each(&blk)
    #   @yieldparam hash [Hash] a hash of columns to their values in this row
    # @overload each
    #   @return [Enumerator] an {::Enumerator} that iterates of the rows in the
    #     file
    # @see FileRow#to_hash
    def each
      return to_enum(:each) unless block_given?

      while (row = shift)
        yield(@return_hash ? row.to_hash : row.to_a)
      end
    end

    # @return [FileRow,nil] the next row from the file, or +nil+ if the end of
    #  the file has been reached.
    def shift
      row = @csv.shift
      file_row(row).tap { @index += 1 } if row
    end

    private

    def file_row(row)
      FileRow.new(@index, @col_names, row, @definition, @do_parse)
    end

    # Check the list of headers in the file against the expected columns in
    # the definition
    def find_columns(validate)
      @found_columns = []
      prefix = "#{filename.yellow}:"

      required = @definition.required_columns
      unless required.empty?
        Log.info { "#{prefix} #{'required columns'.magenta}" } if validate

        missing = check_columns(validate, prefix, required, :green, :red)
        raise RequiredColumnsMissing, missing if validate && missing.present?
      end

      optional = @definition.optional_columns
      unless optional.empty?
        Log.info { "#{prefix} #{'optional columns'.cyan}" } if validate
        check_columns(validate, prefix, optional, :cyan, :light_yellow)
      end

      cols = @definition.columns.collect(&:name)
      headers = @csv_headers.select { |h| cols.include?(h) }

      @col_names ||= @found_columns.map(&:name)
      ::Hash[*headers.inject([]) { |list, c| list << c << @definition[c] }]
    end

    def check_columns(validate, prefix, expected, found_color, missing_color)
      check = '✔'.colorize(found_color)
      cross = '✘'.colorize(missing_color)

      expected.map do |col|
        name = col.name
        missing =
          if @csv_headers.include?(name)
            @found_columns << col
            nil
          else
            name
          end

        if validate
          Log.info do
            mark = missing ? cross : check
            "#{prefix} #{name.to_s.rjust column_width} [#{mark}]"
          end
        end
        missing
      end.compact
    end

    def column_width
      @column_width ||= @definition.columns.collect(&:name).max_by(&:length).length
    end
  end
end
