module Wolverine
  # Enumerator::Generator loaded by default for Ruby 2, but does
  # something slightly different.  Call Enumerator.new with block for
  # compatibility with 1.8.7 Generator class.  (Also, this API makes
  # it a bit easier to implement the InterleaveFilter.)
  class CompatibilityGenerator
    def initialize(source)
      @enumerator = Enumerator.new do |yielder|
        source.each do |item|
          yielder.yield item
        end
      end
    end
    def next
      @enumerator.next
    end
    def end?
      @enumerator.peek
      false
    rescue StopIteration
      return true
    end
    def current
      @enumerator.peek
    end
  end
end
