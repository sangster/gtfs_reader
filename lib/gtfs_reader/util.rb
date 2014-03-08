module GtfsReader 

  class HashContext
    def initialize(hash={})
      @hash = hash
    end

    def method_missing(name, *args)
      @hash[name] = args.first unless args.empty?
      @hash[name]
    end

    def respond_to?(_)
      true
    end
  end
end
