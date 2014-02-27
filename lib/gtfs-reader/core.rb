module GtfsReader
  extend self

  def config(&blk)
    @cfg ||= Configuration.new.tap do |cfg|
      cfg.instance_eval do 
        block_parameter :feed_format, Config::FeedFormat
      end
    end

    @cfg.instance_eval &blk if block_given?
    @cfg
  end
end
