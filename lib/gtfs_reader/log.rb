require 'logger'
require 'colorize'

module GtfsReader
  module Log
    class << self
      def debug(*args, &block)
        log(:debug, *args, &block)
      end

      def info(*args, &block)
        log(:info,  *args, &block)
      end

      def warn(*args, &block)
        log(:warn,  *args, &block)
      end

      def error(*args, &block)
        log(:error, *args, &block)
      end

      def fatal(*args, &block)
        log(:fatal, *args, &block)
      end

      def log(level, *args, &block)
        logger.send(level, *args, &block)
        nil
      end

      def logger
        @logger = yield if block_given?
        @logger ||= create_logger
      end

      def level=(lev)
        logger.level =
          case lev
          when :debug then Logger::DEBUG
          when :info  then Logger::INFO
          when :warn  then Logger::WARN
          when :error then Logger::ERROR
          when :fatal then Logger::FATAL
          else raise "unknown log level '#{lev}'"
          end
      end

      def level
        logger.level
      end

      # Silence the logger for the duration of the given block
      def quiet
        old_logger = @logger
        begin
          @logger = NoOpLogger.new
          yield
        ensure
          @logger = old_logger
        end
      end

      private

      def create_logger
        Logger.new($stderr).tap do |log|
          log.level = Logger::INFO
          log.debug { 'Starting GtfsReader...'.underline.colorize(:yellow) }
        end
      end
    end

    class NoOpLogger
      def method_missing(*_args)
        nil
      end

      def respond_to_missing?(_name, _include_private = false)
        true
      end
    end
  end
end
