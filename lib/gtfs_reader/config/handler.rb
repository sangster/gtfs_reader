module GtfsReader
  module Config
    class Handler
      def initialize(&block)
        raise 'a block is required' unless block_given?
        @block = block
      end

      def call(row)
        @block.call row
      end
    end
  end
end
