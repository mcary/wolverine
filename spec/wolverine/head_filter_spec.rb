require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::HeadFilter do
  it "should count the number of events" do
    filt = Wolverine::HeadFilter.new(Wolverine::ArraySource.new(%w{x y}), 1)
    filt.to_strings.should == ["x"]
  end
end
