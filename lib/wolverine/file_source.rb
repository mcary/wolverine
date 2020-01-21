require 'progressbar'
module Wolverine
  class FileSource < Source
    attr_accessor :progress, :gzip
    def initialize(filename, opts={})
      @filename = filename
      self.progress = opts[:progress]
      self.gzip = opts.key?(:gzip) ? opts[:gzip] : filename.match(/\.gz$/i)
      require 'zlib' if self.gzip
    end
    def each
      progress = self.progress
      if progress
        size = File.size(@filename)
        bar = ProgressBar.create(
          title: @filename,
          total: size,
          format: "%t |%B| %cB %E",
        )
      end
      File.open(@filename, "r") do |file|
        realfile = file
        file = Zlib::GzipReader.new(file) if self.gzip
        bar_update = 10_000
        cnt = 0
        file.each do |line|
          if progress
            if cnt < bar_update
              cnt += 1
            else
              bar.progress = realfile.tell
              cnt = 0
            end
          end
          yield line
        end
      end
      bar.finish if progress
    end
  end
end
