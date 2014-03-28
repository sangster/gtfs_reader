module GtfsReader

  class FileReaderError < StandardError; end
  class RequiredHeaderMissing < FileReaderError; end
  class RequiredFilenameMissing < FileReaderError; end

  module Config
    class FileDefinitionError < StandardError; end
  end
end
