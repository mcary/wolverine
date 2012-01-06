require 'progressbar'
module Wolverine
  class FileSource < Source
    attr_accessor :progress
    def initialize(filename, opts={})
      @filename = filename
      self.progress = opts[:progress]
    end
    def each
      progress = self.progress
      if progress
        size = File.size(@filename)
        bar = ProgressBar.new(@filename, size)
        bar.file_transfer_mode
      end
      File.open(@filename, "r") do |file|
        bar_update = 10_000
        cnt = 0
        file.each do |line|
          if progress
            if cnt < bar_update
              cnt += 1
            else
              bar.set(file.tell)
              cnt = 0
            end
          end
          yield Event.new(line)
        end
      end
      bar.finish if progress
    end
  end
end
