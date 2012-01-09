require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::WhereFilter do
  it "should select only events matching hash" do
    filt = Wolverine::WhereFilter.new(source(%w{x y}),
                                     :to_s => "x")
    filt.to_strings.should == ["x"]
  end
  it "should select only events matching Regexp" do
    filt = Wolverine::WhereFilter.new(source(%w{x y}), /x/)
    filt.to_strings.should == ["x"]
  end
  it "should support regexp matching" do
    filt = Wolverine::WhereFilter.new(source(["barfoo", "foob"]),
                                     :to_s => /\Afoo/)
    filt.to_strings.should == ["foob"]
  end
  def source(ary)
    Wolverine::ArraySource.new(ary)
  end
end

