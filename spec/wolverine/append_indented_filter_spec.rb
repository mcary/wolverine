require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::AppendIndentedFilter do
  it "should append indented lines, stripping indent" do
    filt = Wolverine::AppendIndentedFilter.new ["foo\n", "  bar"]
    ary = filt.map {|ev| ev.to_s}
    ary.should == ["foo\nbar"]
  end
  it "should skip initial indented lines as a partial event" do
    filt = Wolverine::AppendIndentedFilter.new ["  foo\n", "bar\n"]
    ary = filt.map {|ev| ev.to_s}
    ary.should == ["bar\n"]
  end
  it "should output multiple events when appropriate" do
    filt = Wolverine::AppendIndentedFilter.new ["foo\n", "bar\n"]
    ary = filt.map {|ev| ev.to_s}
    ary.should == ["foo\n", "bar\n"]
  end
end
