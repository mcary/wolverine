module Wolverine
  class ActiveRecordClassGenerator
    def initialize(mod, table_name)
      @mod = mod
      @table_name = table_name
    end
    def generate
      # This is no longer permitted by AR: Class.new(ActiveRecord::Base)
      klass_name = [
        "Record",
        table_name.gsub(/[^a-z0-9]+/i, '_'),
        Time.now.to_i,
        rand(100_000_000..1_000_000_000),
      ].join("_")
      eval "class #{mod.name}::#{klass_name} < ActiveRecord::Base; end"
      klass = mod.const_get(klass_name, inherit=false)
      klass.table_name = table_name
      klass
    end
    private
    attr_reader :mod, :table_name
  end
end
