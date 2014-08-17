module GtfsReader
  module Config
    # Defines a single column in a {FileDefinition file}.
    class Column
      # A "parser" which simply returns its input. Used by default
      IDENTITY_PARSER = ->(arg) { arg }

      attr_reader :name

      #@param name [String] the name of the column
      #@option opts [Boolean] :required (false) If this column is required to
      #  appear in the given file
      #@option opts [Boolean] :unique (false) if values in this column need to be
      #  unique among all rows in the file.
      def initialize(name, opts={}, &parser)
        @name = name
        @parser = block_given? ? parser : IDENTITY_PARSER

        @opts = { required: false, unique: false }.merge ( opts || {} )
      end

      def parser(&block)
        @parser = block if block_given?
        @parser
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

      #@return [Boolean]
      def parser?
        parser != IDENTITY_PARSER
      end

      def to_s
        opts = @opts.map do |key,value|
          case value
            when true then key
            when false,nil then nil
            else "#{key}=#{value}"
          end
        end.reject &:nil?

        opts << 'has_parser' if parser?

        str = name.to_s
        str << ": #{opts.join ', '}" unless opts.empty?
        "[#{str}]"
      end
    end
  end
end
