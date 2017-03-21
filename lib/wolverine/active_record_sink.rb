require 'wolverine/active_record_class_generator'

module Wolverine
  class ActiveRecordSink < Sink
    attr_reader :columns, :klass
    def initialize(source, klass)
      super(source)
      @klass = klass
      @columns = klass.columns.map(&:name) - %w{id created_at updated_at}
    end
    def self.create(source, table_name, columns, connection_params)
      require 'active_record'
      gen = ActiveRecordClassGenerator.new(self, table_name)
      klass = gen.generate
      klass.establish_connection(connection_params)
      klass.connection.create_table table_name do |t|
        t.column :text, :text
        columns.each do |col|
          t.column col, :string
        end
        #t.timestamps
      end
      self.new(source, klass)
    end
    def run
      @source.each do |evt|
        hsh = {}
        columns.each {|col| hsh[col] = evt.send(col) }
        rec = @klass.new(hsh)
        rec.save!
      end
    end
  end
end
