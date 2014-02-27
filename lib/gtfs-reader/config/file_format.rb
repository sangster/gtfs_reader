module GtfsReader::Config
  class FileFormat
    attr_reader :name

    def initialize(name, opts={})
      @name, @_cols = name, {}
      @opts = { required: false }.merge (opts || {})
    end

    def required?
      @opts[:required]
    end

    def filename
      "#{name}.txt"
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
      return sym.to_s[0] != '_'
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


  class PrefixedColumnSetter
    def initialize(format, prefix)
      @format, @prefix = format, prefix
    end

    def respond_to?(sym)
      return true
    end

    def method_missing(name_alias, *args, &blk)
      name = "#{@prefix}_#{name_alias}"
      opts = case args.first
        when Hash then args.first
        else {}
      end
      opts[:alias] = name_alias
      args[0] = opts

      @format.method_missing name, *args, &blk
    end
  end
end
