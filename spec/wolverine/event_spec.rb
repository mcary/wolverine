require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::Event.new("foo") do
  its(:to_s) {should == "foo"}
end
