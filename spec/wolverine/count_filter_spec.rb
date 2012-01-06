require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::CountFilter do
  it "should count the number of events" do
    filt = Wolverine::CountFilter.new [:x, :y, :z]
    cnt = 0
    filt.each {|cnt| }
    cnt.to_s.should == "3"
    cnt.should be_a(Wolverine::Event)
  end
end

