begin
  require 'generator' # Ruby 1.8.7
rescue LoadError
  # Enumerator::Generator loaded by default for Ruby 2
  Generator = Enumerator::Generator
end

module Wolverine
  class InterleaveFilter < Filter
    def initialize(source, other_source)
      super(source)
      @other_source = other_source
    end
    def each(&block)
      # The Generator docs warn these are slow b/c they use continuations
      generators = [Generator.new(@source), Generator.new(@other_source)]
      generators.reject!(&:end?)
      while generators.any?
        generators = generators.sort_by(&:current) 
        yield generators.first.next
        generators.shift if generators.first.end?
      end
    end
  end
end
