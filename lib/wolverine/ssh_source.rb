require 'shellwords'

module Wolverine
  class SshSource < Source
    attr_accessor :cmd, :gzip
    def initialize(host, filename, opts={})
      # Use zless to automatically unzip it as required.
      rcmd = "cat #{filename.shellescape}"
      self.cmd = "ssh #{host} #{rcmd.shellescape}"
      self.gzip = opts.key?(:gzip) ? opts[:gzip] : filename.match(/\.gz$/i)
      require 'zlib' if self.gzip
    end
    def each
      IO.popen(cmd) do |file|
        file = Zlib::GzipReader.new(file) if self.gzip
        file.each do |line|
          yield line
        end
      end
    end
  end
end
