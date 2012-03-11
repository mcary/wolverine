module Wolverine
  class LessSink < Sink
    def run
      IO.popen(pager_command, "a") do |pipe|
        @source.each {|evt| pipe.puts evt }
        nil
      end
    end
    def pager_command
      "less"
    end
  end
end

