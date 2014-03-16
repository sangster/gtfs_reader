module GtfsReader
  module Version
    MAJOR = 2
    MINOR = 0
    PATCH = 1
    BUILD = nil

    def self.to_s
      [MAJOR, MINOR, PATCH, BUILD].compact.join '.'
    end
  end
end
