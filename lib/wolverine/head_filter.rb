module Wolverine
  class HeadFilter < Filter
    def initialize(source, count)
      @count = count
      super(source)
    end
    def each
      cnt = 0
      @source.each do |evt|
        return if cnt >= @count
        yield evt
        cnt += 1
      end
    end
  end
end

