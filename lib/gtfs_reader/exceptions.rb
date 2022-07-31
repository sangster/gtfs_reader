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

  GtfsError = Class.new(StandardError)
  HttpError = Class.new(GtfsError)
  UnknownSourceError = Class.new(GtfsError)
  SkipSourceError = Class.new(GtfsError)
  HandlerMissingError = Class.new(GtfsError)

  module Config
    SourceDefinitionError = Class.new(GtfsError)
    FileDefinitionError = Class.new(GtfsError)
  end
end
