module Wolverine
  class Enumerable
    include ::Enumerable
    include FilterDSL
    def to_strings
      map {|el| el.to_s}
    end
    def to_a
      filterize super
    end
    def map(*args)
      filterize super
    end
    alias collect map

    protected

    def filterize(arr)
      arr.extend(FilterDSL)
      arr
    end
  end
end
