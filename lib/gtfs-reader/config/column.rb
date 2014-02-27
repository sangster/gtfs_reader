module GtfsReader::Config  
  class Column
    attr_reader :name

    def initialize(name, opts={})
      @name = name
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
