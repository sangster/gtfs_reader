require_relative 'source'

module GtfsReader
  module Config
    class Sources < ::BasicObject
      def initialize
        @sources = {}
      end

      def each &block
        @sources.each &block
      end

      def method_missing(name, *args, &block)
        (@sources[name] ||= Source.new name).tap do |src|
          src.instance_exec src, &block if ::Kernel.block_given?
        end
      end

      def respond_to?(name)
        true
      end
    end
  end
end
