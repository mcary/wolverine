module Wolverine
  module FilterDSL
    def append_indented
      AppendIndentedFilter.new(self)
    end
    def count
      CountFilter.new(self)
    end
  end
end
