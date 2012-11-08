module Wolverine
  module FilterDSL
    def append_indented
      AppendIndentedFilter.new(self)
    end
    def field(regex, *fields)
      FieldFilter.new(self, regex, *fields)
    end
    def parse_time(source_field, dest_field=source_field)
      ParseTimeFilter.new(self, source_field, dest_field)
    end
    def head(count, opts={})
      HeadFilter.new(self, count, opts)
    end
    def where(conditions=nil)
      WhereFilter.where(self, conditions)
    end
    def count
      CountSink.new(self).run
    end
    def less
      LessSink.new(self).run
    end
    def save_file(filename)
      FileSink.new(self, filename).run
    end
    def save_records(active_record_klass)
      ActiveRecordSink.new(self, active_record_klass).run
    end
    def group(opts)
      GroupFilter.new(self, opts)
    end
    def interleave(other_source)
      InterleaveFilter.new(self, other_source)
    end
  end
end
