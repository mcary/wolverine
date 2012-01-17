require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::GroupFilter do
  it "should group lines with a common field value" do
    klass = Struct.new :to_s, :field1
    filt = Wolverine::GroupFilter.new [
      klass.new("foo", "x"),
      klass.new("bar", "x"),
    ], :following => :field1
    ary = filt.to_strings
    ary.should == ["foobar"]
  end
  it "should segregate lines with a different field value" do
    klass = Struct.new :to_s, :field1
    filt = Wolverine::GroupFilter.new [
      klass.new("foo", "x"),
      klass.new("bar", "y"),
    ], :following => :field1
    ary = filt.to_strings
    ary.should == ["foo", "bar"]
  end
  describe "with :from" do
    it "should start new group on match" do
      klass = Struct.new :to_s, :field1
      filt = Wolverine::GroupFilter.new [
        klass.new("foo", "x"),
        klass.new("bar", "x"),
        klass.new("foo", "x"),
        klass.new("bar", "x"),
      ], :following => :field1, :from => /foo/
      ary = filt.to_strings
      ary.should == ["foobar", "foobar"]
    end
    it "should exclude a leading fragment group" do
      klass = Struct.new :to_s, :field1
      filt = Wolverine::GroupFilter.new [
        klass.new("bar", "x"),
        klass.new("foo", "x"),
        klass.new("bar", "x"),
      ], :following => :field1, :from => /foo/
      ary = filt.to_strings
      ary.should == ["foobar"]
    end
  end
end

