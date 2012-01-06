module Wolverine
  class FileSource < Source
    def initialize(filename)
      @filename = filename
    end
    def each
      File.foreach(@filename) do |line|
        yield Event.new(line)
      end
    end
  end
end
