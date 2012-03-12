module Wolverine
  class FieldFilter < Filter
    def initialize(source, regex, *fields)
      super(source)
      @regex = regex
      @fields = fields
      @class = Class.new(Event)
      @class.class_eval <<-EOF
        def initialize(text, evt, *flds)
          super(text)
          @evt = evt
          #{@fields.map {|f| "@#{f}" }.join(", ")} =
            #{@fields.size > 1 ? "flds" : "flds.first"}
        end
        def method_missing(name, *args)
          # Danger: bypassing method access modifier (private/protected)
          @evt.send(name) if args.empty?
        end
      EOF
      @class.send(:attr_reader, *@fields)
    end
    def each
      @source.each do |evt|
        md = @regex.match(evt.to_s)
        if md
          yield @class.new(evt.to_s, evt, *md[1..md.length])
        else
          # Tired of no such method exceptions...
          yield @class.new(evt.to_s, evt, *@fields.map {nil})
          # was:
          #yield evt
        end
      end
    end
  end
end
