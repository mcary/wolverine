module Wolverine
  class ArraySource < Source
    def initialize(array)
      @array = array
    end
    def each
      @array.each {|str| yield Event.new(str) }
    end
  end
end
