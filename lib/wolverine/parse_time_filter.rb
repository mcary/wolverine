module Wolverine
  class ParseTimeFilter < FieldFilter
    def initialize(source, source_field, dest_field=source_field)
      @source_field = source_field
      @dest_field = dest_field
      super(source, nil, dest_field)
      # each is defined by eval in superclass
      #self.send(:alias_method, :each, :_each)
      def self.each(*args, &block)
        _each(*args, &block)
      end
    end

    def _each
      @source.each do |evt|
        ts_text = evt.send(@source_field)
        ts = Time.parse(ts_text) if ts_text
        yield @class.new(evt.to_s, evt, ts)
      end
    end
  end
end
