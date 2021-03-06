require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::AppendIndentedFilter do
  it "should append indented lines, stripping indent" do
    filt = Wolverine::AppendIndentedFilter.new source(["foo\n", "  bar"])
    ary = filt.to_strings
    ary.should == ["foo\nbar"]
  end
  it "should skip initial indented lines as a partial event" do
    filt = Wolverine::AppendIndentedFilter.new source(["  foo\n", "bar\n"])
    ary = filt.to_strings
    ary.should == ["bar\n"]
  end
  it "should output multiple events when appropriate" do
    filt = Wolverine::AppendIndentedFilter.new source(["foo\n", "bar\n"])
    ary = filt.to_strings
    ary.should == ["foo\n", "bar\n"]
  end
  def source(ary)
    Wolverine::ArraySource.new(ary)
  end
end
