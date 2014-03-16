module GtfsReader
  class Configuration

    # Creates simple configuration parameters which may be set by the user
    #@param names [Array<Symbol>] the names of the parameters to create
    def parameter(*names)
      names.each do |name|
        define_singleton_method name do |*values|
          if value = values.first
            instance_variable_set "@#{name}", value
          else
            instance_variable_get "@#{name}"
          end
        end
      end
    end

    def block_parameter(name, obj_class, *init_args)
      obj = nil
      define_singleton_method name do |*args,&blk|
        (obj ||= obj_class.new *init_args).tap do |o|
          o.instance_eval( *args, &blk ) if blk
        end
      end
    end
  end
end
