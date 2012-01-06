module Wolverine
  class Enumerable
    include ::Enumerable
    include FilterDSL
    def to_strings
      map {|el| el.to_s}
    end
  end
end
