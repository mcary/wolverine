require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::CountSink do
  it "should count the number of events" do
    sink = Wolverine::CountSink.new [:x, :y, :z]
    sink.run.should == 3
  end
end
