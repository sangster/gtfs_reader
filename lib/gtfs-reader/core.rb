module GtfsReader
  def self.config
    cfg = Configuration.new
    
    yield cfg if block_given?
    cfg
  end
end
