module Wolverine
  class IoSource < Wolverine::Source
    def initialize(io)
      @io = io
    end
    def each
      @io.each do |line|
        yield line
      end
    end
  end
end
