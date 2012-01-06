module Wolverine
  class CountFilter < Filter
    def each
      cnt = 0
      @source.each {|evt| cnt += 1 }
      yield Event.new cnt.to_s
    end
  end
end
