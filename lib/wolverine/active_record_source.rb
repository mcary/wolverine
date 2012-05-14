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
      if can_search_with_conditions
        evts = @klass.where({})
        evts = evts.where(@conds) if !@conds.empty?
        evts = evts.where(["text like ?", "%#{@search}%"]) if @search
      else
        if @search
          evts = @klass.find(:all, :conditions =>
                                      ["text like ?", "%#{@search}%"])
        else
          evts = @klass.find(:all, :conditions => @conds)
        end
      end
      evts.each {|rec| yield rec }
    end
    def where(conditions=nil)
      if @search && !can_search_with_conditions
        raise Exception, "Can't do both where and search"
      end

      if conditions
        @conds = @conds.merge(conditions)
        self
      else
        # Get ready for where.not(...), which should happen in-memory
        super(conditions)
      end
    end
    def search(word)
      if @conds && !can_search_with_conditions
        raise Exception, "Can't do both search and where"
      end
      @search = word
      self
    end
    def can_search_with_conditions
      @klass.respond_to? :where
    end
  end
end
