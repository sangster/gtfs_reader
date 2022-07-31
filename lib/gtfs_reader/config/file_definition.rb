# frozen_string_literal: true

require_relative 'column'

module GtfsReader
  module Config
    # Describes a single file in a {FeedDefinition GTFS feed}.
    class FileDefinition
      attr_reader :name

      # @param name [String] The name of the file within the feed.
      # @option opts [Boolean] :required (false)
      #   If this file is required to be in the feed.
      def initialize(name, opts = {})
        @name = name
        @columns = {}
        @opts = { required: false }.merge(opts || {})
      end

      # @return [Boolean] If this file is required to be in the feed.
      def required?
        @opts[:required]
      end

      # @return [String] The filename of this file within the GTFS feed.
      def filename
        "#{name}.txt"
      end

      # @return [Column] The column with the given name
      def [](name)
        @columns[name]
      end

      def columns
        @columns.values
      end

      # @return [Array<Column>] The columns required to appear in this file.
      def required_columns
        columns.select(&:required?)
      end

      # @return [Array<Column>] The columns not required to appear in this file.
      def optional_columns
        columns.reject(&:required?)
      end

      # @return [Array<Column>] The columns which cannot have two rows with the
      #   same value.
      def unique_columns
        columns.select(&:unique?)
      end

      # Creates a column with the given name.
      #
      # @param name [String] The name of the column to define.
      # @param args [Array] The first element of this args list is used as a
      #   +Hash+ of options to create the new column with.
      # @param block [Proc] An optional block used to parse the values of this
      #   column on each row.
      # @yieldparam input [String] The value of this column for a particular
      #   row.
      # @yieldreturn Any kind of object.
      # @return [Column] The newly created column.
      def col(name, *args, &)
        if @columns.key?(name)
          @columns[name].parser(&) if block_given?
          return @columns[name]
        end

        @columns[name] = Column.new(name, args.first, &)
      end

      # Creates an input-output proc to convert column values from one form to
      # another.
      #
      # Many parser procs simply map a set of known values to another set of
      # known values. This helper creates such a proc from a given hash and
      # optional default.
      #
      # @param reverse_map [Hash] A map of returns values to their input values.
      #  This is in reverse because it looks better, like a list of labels:
      #  +{bus: 3, ferry: 4}+
      # @param default [] The value to return if there is no mapping for a given
      #    input.
      def output_map(reverse_map, default = nil)
        if reverse_map.values.uniq.length != reverse_map.values.length
          raise FileDefinitionError, "Duplicate values given: #{reverse_map}"
        end

        map = default.nil? ? {} : Hash.new(default)
        reverse_map.each { |k, v| map[v] = k }
        map.method(:[]).to_proc
      end
    end
  end
end
