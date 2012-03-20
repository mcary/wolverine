require File.dirname(__FILE__)+"/../spec_helper"
require "tempfile"
describe Wolverine::FileSource do
  it "should iterate through records" do
    Tempfile.open("wol-spec") do |file|
      src = ActiveRecordSource.open("events", 
                                    :adapter => "sqlite3",
                                    :database => file.path)
      src.klass.connection.create_table "events" do |t|
        t.column :foo, :string
        t.column :text, :text
        t.timestamps
      end
      src.klass.create(:foo => "bar", :text => "baz bar")

      ary = src.to_a
      ary.length.should == 1
      evt = ary.first
      evt.to_s.should == "baz bar"
      evt.foo.should == "bar"
    end
  end
  it "should allow conditions via where()" do
    Tempfile.open("wol-spec") do |file|
      src = ActiveRecordSource.open("events",
                                    :adapter => "sqlite3",
                                    :database => file.path)
      src.klass.connection.create_table "events" do |t|
        t.column :foo, :string
        t.column :text, :text
        t.timestamps
      end
      src.klass.create(:foo => "bar", :text => "baz bar")
      src.klass.create(:foo => "baz", :text => "baz bar")

      ary = src.where(:foo => "baz").to_a
      ary.length.should == 1
      evt = ary.first
      evt.to_s.should == "baz bar"
      evt.foo.should == "baz"
    end
  end
end
