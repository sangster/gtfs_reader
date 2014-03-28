require 'log4r'
require 'log4r/config'
require 'colorize'

module GtfsReader
  module Log
    extend self

    def debug(*args, &block)
      log :debug, *args, &block
    end

    def info(*args, &block)
      log :info, *args, &block
    end

    def warn(*args, &block)
      log :warn, *args, &block
    end

    def error(*args, &block)
      log :error, *args, &block
    end

    def fatal(*args, &block)
      log :fatal, *args, &block
    end

    def log( level, *args, &block)
      logger.send level, *args, &block
      nil
    end

    def logger
      @logger ||= create_logger
    end

    def level=(lev)
      logger.level = lev
    end

    def level
      logger.level
    end

    private

    def create_logger
      Log4r::Logger.new('GtfsReader').tap do |log|
        log.outputters << Log4r::StdoutOutputter.new('log_stdout')
        log.level = Log4r::DEBUG
        log.debug { 'Starting GtfsReader...'.underline.colorize :yellow }
      end
    end
  end
end
