module Wolverine
  class Enumerable
    include ::Enumerable
    include FilterDSL
  end
end
