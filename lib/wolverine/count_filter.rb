module Wolverine
  class CountFilter < Filter
    def each
      cnt = 0
      @source.each {|evt| cnt += 1 }
      yield cnt
    end
  end
end
