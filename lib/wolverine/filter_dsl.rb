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
    def where(conditions=nil)
      WhereFilter.where(self, conditions)
    end
    def less
      LessSink.new(self).run
    end
    def group(opts)
      GroupFilter.new(self, opts)
    end
  end
end
