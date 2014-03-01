require 'csv'

module GtfsReader
  CSV_OPTIONS = { headers: true,
                  return_headers: true,
                  header_converters: :symbol }

  class FileReader

    attr_reader :definition, :columns

    def initialize(data, definition)
      @csv = CSV.new data, CSV_OPTIONS
      @definition = definition
      @columns = validate_columns @csv.shift.headers
    end

    private

    def validate_columns(headers)
      @definition.required_columns.collect( &:name ).each do |col|
        raise RequiredHeaderMissing, col.to_s unless headers.include? col
      end

      cols = @definition.columns.collect &:name
      headers = headers.select {|h| cols.include? h }

      Hash[ *headers.collect {|col| [col, @definition[col]] }.flatten ]
    end
  end
end
