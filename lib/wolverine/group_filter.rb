module Wolverine
  class GroupFilter < Filter
    def initialize(source, opts)
      super(source)
      @following = arg_to_a(opts[:following])
      @from = opts[:from]
    end
    def each
      groups = Hash.new { |hash,k| hash[k] = [] }
      @source.each do |evt|
        key = @following.map {|meth| evt.send(meth) }
        group = groups[key] 
        if @from
          if @from.match(evt.to_s)
            if group.any?
              yield merge_events(group)
              group.clear
            end
            group.push(evt)
          else
            group.push(evt) unless group.empty?
          end
        else
          group.push(evt)
        end
      end
      # ordering?
      groups.each do |k,group|
        yield merge_events(group)
      end
    end
    private
    def arg_to_a(arg)
      if Array === arg
        arg
      else
        [arg]
      end
    end
    def merge_events(group)
      Event.new(group.map {|evt| evt.to_s }.join(""))
    end
  end
end

