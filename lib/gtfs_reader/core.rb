require_relative 'configuration'
require_relative 'config/feed_definition'
require_relative 'config/sources'
require_relative 'source_updater'

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

  def update_all!
    config.sources.each {|name, _| update name }
  end

  def update(name)
    if config.verbose
      update_verbosely name
    else
      Log.quiet { update_verbosely name }
    end
  end

  private

  def update_verbosely(name)
    source = config.sources[name]
    raise UnknownSourceError, "No source named '#{name}'" if source.nil?
    updater = SourceUpdater.new name, source
    begin
      updater.instance_exec do
        Log.info { "Updating #{name.to_s.green}".underline }
        before_callbacks
        read
        check_files
        check_columns
        process_files
        Log.info { "Finished updating #{name.to_s.green}" }
      end
    rescue SkipSourceError => e
      Log.warn do
        msg = e.message ? ": #{e.message}" : ''
        "#{'Skipping'.red} #{source.name.to_s.yellow}" + msg
      end
    ensure
      updater.finish
    end
  end

  def create_config
    Configuration.new.tap do |cfg|
      cfg.instance_exec do
        parameter :verbose
        parameter :skip_parsing
        parameter :return_hashes
        block_parameter :sources, Config::Sources
        block_parameter :feed_definition, Config::FeedDefinition
      end
    end
  end
end
