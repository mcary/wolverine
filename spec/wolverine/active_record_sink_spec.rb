require File.dirname(__FILE__)+"/../spec_helper"
require "tempfile"
describe Wolverine::ActiveRecordSink do
  it "should write events to a table" do
    Tempfile.open("wol-spec") do |file|
      source = Wolverine::ArraySource.new(["x y"])
      filt = Wolverine::FieldFilter.new(source, /(x)/, :x)
      sink = Wolverine::ActiveRecordSink.create(filt, "events", [:x],
                                                :adapter => "sqlite3",
                                                :database => file.path)

      sink.run

      klass = Class.new(ActiveRecord::Base)
      klass.class_eval { self.table_name = "events" }
      events = klass.all
      events.length.should == 1
      events.first.x.should == "x"
      events.first.text.should == "x y"
    end
  end
end
