module Wolverine
  class FileSink < Sink
    def initialize(source, filename)
      super(source)
      @filename = filename
    end
    def run
      File.open(@filename, "w") do |file|
        @source.each {|evt| file.write(evt) }
      end
    end
  end
end
