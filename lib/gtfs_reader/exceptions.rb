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

  class UnknownSourceError < StandardError; end
  class SkipSourceError < StandardError; end
  class HandlerMissingError < StandardError; end

  module Config
    class SourceDefinitionError < StandardError; end
    class FileDefinitionError < StandardError; end
  end
end
