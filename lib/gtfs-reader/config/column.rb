module GtfsReader::Config  
  class Column
    NO_OP_PARSER = ->(arg) { arg }

    attr_reader :name, :parser

    def initialize(name, opts={}, &parser)
      @name = name
      @parser = block_given? ? parser : NO_OP_PARSER

      @opts = { 
        required: false, 
        alias: nil,
        unique: false
      }.merge (opts || {})
    end

    def required?
      @opts[:required]
    end

    def unique?
      @opts[:unique]
    end

    def alias
      @opts[:alias]
    end
  end
end
