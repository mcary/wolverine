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
    def head(count, opts={})
      HeadFilter.new(self, count, opts)
    end
    def where(conds)
      WhereFilter.new(self, conds)
    end
  end
end
