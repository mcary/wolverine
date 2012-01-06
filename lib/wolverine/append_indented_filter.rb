module Wolverine
  class AppendIndentedFilter < Filter
    def each
      evts = nil
      @source.each do |evt|
        if evt.to_s.start_with? prefix
          if !evts.nil?
            evts.push evt
            # else drop the partial event
          end
        else
          if !evts.nil?
            yield merge_events(evts)
          end
          evts = [evt]
        end
      end
      if !evts.nil?
        yield merge_events(evts)
      end
    end
    def merge_events(evts)
      if evts.size == 1
        evts.first
      else
        text = evts.shift.to_s
        text += evts.map do |evt|
          str = evt.to_s
          str.slice(prefix.length..str.length)
        end.join("")
        Event.new(text)
      end
    end
    def prefix
      "  "
    end
  end
end
