require_relative 'source'

module GtfsReader
  module Config
    class Sources < ::BasicObject
      def initialize
        @sources = {}
      end

      def each(&block)
        @sources.each(&block)
      end

      def [](key)
        @sources[key]
      end

      def method_missing(name, *_args, &block)
        (@sources[name] ||= Source.new name).tap do |src|
          src.instance_exec(src, &block) if ::Kernel.block_given?
        end
      end

      def respond_to_missing?(_name, _include_private = false)
        true
      end
    end
  end
end
