module Wolverine
  class AppendIndentedFilter < Filter
    def each
      merged_evt = nil
      @source.each do |evt|
        if evt.to_s.start_with? prefix
          if merged_evt
            merged_evt = merge_events(merged_evt, evt)
            # else drop the partial event
          end
        else
          if merged_evt
            yield merged_evt
          end
          merged_evt = evt
        end
      end
      if merged_evt
        yield merged_evt
      end
    end
    def merge_events(ev1, ev2)
      str = ev2.to_s
      Event.new(ev1.to_s + str.slice(prefix.length..str.length))
    end
    def prefix
      "  "
    end
  end
end
