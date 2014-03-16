module GtfsReader
  class HashContext < ::BasicObject
    define_method :tap, ::Kernel.instance_method( :tap )
    define_method :send, ::Kernel.instance_method( :send )

    def initialize(hash={})
      @hash = hash
    end

    def method_missing(name, *args)
      @hash[name] = args.first unless args.empty?
      ::Kernel.raise name unless @hash.key? name
      @hash[name]
    end

    def respond_to?(_)
      true
    end
  end
end
