module GtfsReader
  module Config
    class PrefixedColumnSetter
      def initialize(definition, prefix)
        @definition, @prefix = definition, prefix.to_sym
      end

      def col(name_alias, *args, &blk)
        name = "#{@prefix}_#{name_alias}"
        opts =
          case args.first
          when ::Hash then args.first
          else {}
          end
        opts[:alias] = name_alias
        args[0] = opts

        @definition.col name.to_sym, *args, &blk
      end

      def output_map(*args, &block)
        @definition.output_map *args, &block
      end
    end
  end
end
