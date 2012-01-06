require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::CountFilter do
  it "should count the number of events" do
    filt = Wolverine::CountFilter.new [:x, :y, :z]
    cnt = 0
    filt.each {|cnt| }
    cnt.should == 3
  end
end

