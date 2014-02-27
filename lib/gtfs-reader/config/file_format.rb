module GtfsReader::Config
  class FileFormat
    attr_accessor :name

    def initialize(name)
      @name, @required, @optional = name, [], []
    end

    def filename
      "#{name}.txt"
    end

    def required(*arr)
      @required = (@required + arr).uniq if arr.any? or @required
    end

    def optional(*arr)
      @optional = (@optional + arr).uniq if arr.any? or @optional
    end
  end
end
