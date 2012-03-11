module Wolverine
  class CountSink < Sink
    def initialize(source)
      @source = source
    end
    def run
      cnt = 0
      @source.each {|evt| cnt += 1 }
      cnt
    end
  end
end
