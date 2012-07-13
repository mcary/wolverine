module Wolverine
  class ActiveRecordSource < Source
    attr_reader :klass
    def initialize(active_record_klass, conditions={}, search=nil)
      @klass = active_record_klass
      @conds = conditions
      @search = search
      require 'logger'
      ActiveRecord::Base.logger = Logger.new(STDOUT)
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
        if @search
          evts = evts.where(["text like ?", "%#{@search}%"])
          # Add a fulltext search if we're on MySQL.  Boolean fulltext search
          # is slightly less strict than "like", so it will only be a prefilter.
          # Fixme: table could be Innodb...
          if !@search.include? '"' and
              evts.connection.class.name.include? "Mysql"
            evts = evts.where(["MATCH (text) AGAINST (? IN BOOLEAN MODE)",
                               "\"#{@search}\""])
          end
        end
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
        conds = @conds.merge(conditions)
        return self.class.new(@klass, conds, @search)
      else
        # Get ready for where.not(...), which should happen in-memory
        super(conditions)
      end
    end
    def search(word)
      if @conds && !can_search_with_conditions
        raise Exception, "Can't do both search and where"
      end
      self.class.new(@klass, @conds, word)
    end
    def can_search_with_conditions
      @klass.respond_to? :where
    end
  end
end
