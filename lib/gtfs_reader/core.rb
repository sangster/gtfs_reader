module GtfsReader
  extend self

  #@override config(*args, &blk)
  #  @param args [Array] an array or arguments to pass to the given block
  #  @param blk [Proc] a block to to call in the context of the configuration
  #    object. Subsequent calls will use the same configuration for additional
  #    modification.
  #  @return [Configuration] the configuration object
  #
  #@override config
  #  @return [Configuration] the configuration object
  def config(*args, &blk)
    @cfg ||= create_config

    if block_given?
      @cfg.instance_exec *args.unshift(@cfg), &blk
    elsif args.any?
      raise ArgumentError, 'arguments given without a block'
    end

    @cfg
  end

  private

  def create_config
    Configuration.new.tap do |cfg|
      cfg.instance_exec do
        block_parameter :feed_definition, Config::FeedDefinition
      end
    end
  end
end
