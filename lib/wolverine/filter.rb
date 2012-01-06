module Wolverine
  # Hrm... a filter emits events but isn't really a source...
  class Filter < Source
    def initialize(source)
      @source = source
    end
    # The base filter implements the identity transformation.
    def each(&block)
      @source.each(&block)
    end
  end
end
