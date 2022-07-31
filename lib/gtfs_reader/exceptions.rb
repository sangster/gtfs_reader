# frozen_string_literal: true

module GtfsReader
  class FileReaderError < StandardError; end

  class RequiredColumnsMissing < FileReaderError
    attr_reader :columns

    def initialize(columns)
      @columns = columns
      super "Required columns missing: #{columns.join ', '}"
    end
  end

  class RequiredFilenamesMissing < FileReaderError
    attr_reader :filenames

    def initialize(filenames)
      @filenames = filenames
      super "Required files missing from zip file: #{filenames.join ', '}"
    end
  end

  UnknownSourceError = Class.new(StandardError)
  SkipSourceError = Class.new(StandardError)
  HandlerMissingError = Class.new(StandardError)

  module Config
    SourceDefinitionError = Class.new(StandardError)
    FileDefinitionError = Class.new(StandardError)
  end
end
