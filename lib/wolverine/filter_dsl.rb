module Wolverine
  module FilterDSL
    def append_indented
      AppendIndentedFilter.new(self)
    end
    def count
      CountFilter.new(self)
    end
    def field(regex, *fields)
      FieldFilter.new(self, regex, *fields)
    end
  end
end
