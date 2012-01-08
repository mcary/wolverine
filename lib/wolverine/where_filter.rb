module Wolverine
  class WhereFilter < Filter
    def initialize(source, conds)
      super(source)
      @conds = conds
    end
    def each
      cnt = 0
      @source.each do |evt|
        next unless matches?(evt)
        yield evt
      end
    end
    def matches?(evt)
      @conds.each do |k,v|
        return false unless v === evt.send(k)
      end
      return true
    end
  end
end
