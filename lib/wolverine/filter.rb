module Wolverine
  class Filter < Wolverine::Enumerable
    def initialize(source)
      @source = source
    end
    # The base filter implements the identity transformation.
    def each(&block)
      @source.each(&block)
    end
  end
end
