module GtfsReader 
  class HashContext
    def initialize(hash)
      @hash = hash
    end

    def respond_to?(name)
      @hash.key? name
    end

    def method_missing(name)
      @hash.fetch name
    end
  end
end
