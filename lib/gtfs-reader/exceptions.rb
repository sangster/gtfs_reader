module GtfsReader

  class FileReaderError < StandardError; end
  class RequiredHeaderMissing < FileReaderError; end

  module Config
    class FileDefinitionError < StandardError; end
  end
end
