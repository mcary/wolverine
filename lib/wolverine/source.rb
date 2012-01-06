module Wolverine
  class Source < Wolverine::Enumerable
    def each(&block)
      raise Exception, "Override me"
      yield event
    end
  end
end
