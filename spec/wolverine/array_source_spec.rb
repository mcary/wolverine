require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::FileSource do
  it "should iterate through elements, converting to events" do
    src = Wolverine::ArraySource.new %w{foo bar}
    ary = src.to_a
    strs = ary.map {|el| el.to_s}
    strs.should == ["foo", "bar"]
    ary.first.should be_a(Wolverine::Event)
  end
end


