module GtfsReader
  class Configuration

    ##
    # Creates simple configuration paramters which may be set by the user
    def parameter(*names)
      names.each do |name|
        define_singleton_method name do |*values|
          value = values.first
          value ? instance_variable_set("@#{name}", value) : instance_variable_get("@#{name}")
        end
      end
    end

    def block_parameter(name, obj_class)
      obj = obj_class.new
      instance_variable_set "@#{name}", obj

      define_singleton_method name do |&blk|
        obj.instance_eval &blk if blk
        obj
      end
    end

    def config(&block)
      instance_eval &block
    end
  end
end
