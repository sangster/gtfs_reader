module GtfsReader::Config
  class FileFormat
    attr_reader :_name

    def initialize(name, opts={})
      @_name, @_cols = name, {}
      @opts = { required: false }.merge (opts || {})
    end

    def required?
      @opts[:required]
    end

    def _filename
      "#{_name}.txt"
    end

    def required_cols
      @_cols.values.select &:required?
    end

    def optional_cols
      @_cols.values.reject &:required?
    end

    def unique_cols
      @_cols.values.select &:unique?
    end

    def respond_to?(sym)
      sym.to_s[0] != '_' or super
    end

    def method_missing(name, *args, &blk)
      col = (@_cols[name] = Column.new name, args.first)

      define_singleton_method( col.name ) { |*_| col }
      define_singleton_method( col.alias ) { |*_| col } if col.alias

    end

    def prefix(sym, &blk)
      prefix = "#{sym.to_s}"

      PrefixedColumnSetter.new(self, prefix).instance_eval &blk
    end
  end
end
