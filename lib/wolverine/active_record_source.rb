module Wolverine
  class ActiveRecordSource < Source
    attr_reader :klass
    def initialize(active_record_klass)
      @conds = {}
      @klass = active_record_klass
    end
    def self.open(table_name, connection_params)
      require 'active_record'
      klass = Class.new(ActiveRecord::Base)
      klass.class_eval do
        set_table_name table_name
        def to_s
          text
        end
      end
      klass.establish_connection(connection_params)
      self.new(klass)
    end
    def each
      @klass.find(:all, :conditions => @conds) {|rec| yield rec }
    end
    def where(conditions={})
      @conds = conditions
      self
    end
  end
end
