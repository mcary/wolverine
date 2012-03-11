module Wolverine
  class Sink
    def initialize(source)
      @source = source
    end
    def run
      @source.each { }
      nil
    end
  end
end
