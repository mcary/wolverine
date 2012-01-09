module Wolverine
  class WhereFilter < Filter
    attr_reader :conditions
    def initialize(source, conditions)
      super(source)
      @conditions = Conditions.new(self, conditions)
    end
    def each
      @source.each do |evt|
        next unless @conditions.match?(evt)
        yield evt
      end
    end
    def self.where(source, conditions=nil)
      where = WhereFilter.new(source, conditions)
      if conditions
        where
      else
        where.conditions
      end
    end
  end

  class Conditions
    def initialize(where, conds=nil)
      @where = where
      set_conds(conds)
    end
    def match?(evt)
      @conditions_hash.each do |k,v|
        return @negate unless v === evt.send(k)
      end
      return !@negate
    end
    def not(conds)
      set_conds(conds)
      @negate = true
      @where
    end
    private
    def set_conds(conds)
      return unless conds
      @conditions_hash = case conds
        when Regexp then {:to_s => conds}
        when Hash then conds
        else raise ArgumentError, "Unknown parameter type: #{conds.class}"
        end
    end
  end
end
