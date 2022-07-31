# frozen_string_literal: true

require 'logger'
require 'colorize'

module GtfsReader
  module Log
    class << self
      def debug(*args, &)
        log(:debug, *args, &)
      end

      def info(*args, &)
        log(:info,  *args, &)
      end

      def warn(*args, &)
        log(:warn,  *args, &)
      end

      def error(*args, &)
        log(:error, *args, &)
      end

      def fatal(*args, &)
        log(:fatal, *args, &)
      end

      def log(level, *args, &)
        logger.send(level, *args, &)
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
