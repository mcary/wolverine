module Wolverine
  class FieldFilter < Filter
    def initialize(source, regex, *fields)
      super(source)
      @regex = regex
      @fields = fields
      @class = Class.new(Array)
      @class.class_eval(<<-EOF, __FILE__, __LINE__)
        #{
          # Create accessors that know the index of their field in the array. 
          (0...@fields.size).
            map do |i|
              f = @fields[i]
              "def #{f}; self[#{2+i}]; end"
            end.join("\n"+(" "*8))
        }
        def text; self[0]; end
        def to_s; self[0]; end
        def method_missing(name, *args)
          # Danger: bypassing method access modifier (private/protected)
          self[1].send(name) if args.empty?
        end
      EOF
    end
    def each
      @source.each do |evt|
        md = @regex.match(evt.to_s)
        field_vals = md ? md[1..md.length] : []
        arr = @class.new(2+field_vals.size)
        arr[0...arr.size] = evt.to_s, evt, *field_vals
        yield arr
        #yield @class.new(evt.to_s, evt, *md[1..md.length])
      end
    end
  end
end
