module Wolverine
  class FieldFilter < Filter
    def initialize(source, regex, *fields)
      super(source)
      @regex = regex
      @fields = fields
      @class = Class.new(Event)
      @class.class_eval <<-EOF, __FILE__, __LINE__
        def initialize(text, evt, #{@fields.join(", ")})
          super(text)
          @evt = evt
          #{@fields.map {|f| "@#{f}" }.join(", ")} = #{@fields.join(", ")}
        end
        def method_missing(name, *args)
          # Danger: bypassing method access modifier (private/protected)
          @evt.send(name) if args.empty?
        end
      EOF
      @class.send(:attr_reader, *@fields)
      # Explicitly enumerating the variables passed is faster than splat
      self.instance_eval <<-EOF, __FILE__, __LINE__
        def self.each
          @source.each do |evt|
            md = @regex.match(evt.to_s) || []
            #md = ["pepper.bp", "12345"]
            #{@fields.join(", ")} =
              #{@fields.length > 1 ? "md[1..#{@fields.length}]" : "md[1]"}
            yield @class.new(evt.to_s, evt, #{@fields.join(", ")})
          end
        end
      EOF
    end
  end
end
