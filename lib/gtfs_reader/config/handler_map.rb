require_relative 'handler'

module GtfsReader
  module Config
    class HandlerMap
      def initialize
        @handlers = ::Hash.new { |h,k| h[k] = [] }
      end

      def file(filename, &block)
        Handler.new(&block).tap do |handler|
          @handlers[filename] << handler
        end
      end

      def handler?(filename)
        @handlers.key? filename
      end

      def enum_for(filename)
        ::Kernel.raise :no_handler unless handler? filename
        @handlers[filename].to_enum
      end
    end
  end
end
