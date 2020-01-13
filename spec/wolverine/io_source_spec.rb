require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::FileSource do
  it "should iterate through lines" do
    src = Wolverine::IoSource.new StringIO.new("foo\nbar\n")
    ary = src.to_a
    ary.should == ["foo\n", "bar\n"]
  end
end
