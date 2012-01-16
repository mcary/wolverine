module Wolverine
  class LessSink
    def initialize(source)
      @source = source
    end
    def run
      IO.popen("less", "a") do |pipe|
        @source.each {|evt| pipe.puts evt }
      end
    end
  end
end

