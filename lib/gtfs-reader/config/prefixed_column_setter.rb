module GtfsReader::Config
  class PrefixedColumnSetter
    def initialize(format, prefix)
      @format, @prefix = format, prefix.to_sym
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
