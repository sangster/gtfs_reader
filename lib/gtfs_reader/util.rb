module GtfsReader 

  class HashContext
    def initialize(hash)
      hash.each do |key,value|
        unless  key.respond_to? :to_sym
          raise KeyError, "key must be a symbol: #{key} (class: #{key.class})"
        end

        define_singleton_method( key.to_sym ) { value }
      end
    end
  end
end
