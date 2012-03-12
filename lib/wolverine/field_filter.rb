module Wolverine
  class FieldFilter < Filter
    def initialize(source, regex, *fields)
      super(source)
      @regex = regex
      @fields = fields
      @class = Class.new(Event)
      @class.class_eval <<-EOF
        def initialize(text, *flds)
          super(text)
          #{@fields.map {|f| "@#{f}" }.join(", ")} =
            #{@fields.size > 1 ? "flds" : "flds.first"}
        end
      EOF
      @class.send(:attr_reader, *@fields)
    end
    def each
      @source.each do |evt|
        md = @regex.match(evt.to_s)
        if md
          yield @class.new(evt.to_s, *md[1..md.length])
        else
          # Tired of no such method exceptions...
          yield @class.new(evt.to_s, *@fields.map {nil})
          # was:
          #yield evt
        end
      end
    end
  end
end
