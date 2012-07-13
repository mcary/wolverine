require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::Enumerable, "to_strings" do
  subject do
    Class.new(Wolverine::Enumerable) do
      def each(&block)
        [1, 2].each(&block)
      end
    end.new
  end
  it "should convert contents to strings" do
    subject.to_strings.should == ["1", "2"]
  end
  it "should allow filters to be applied to #map result" do
    subject.map {|x| x}.should respond_to(:append_indented)
  end
  it "should allow filters to be applied to #collect result" do
    subject.collect {|x| x}.should respond_to(:append_indented)
  end
  it "should allow filters to be applied to #to_a result" do
    subject.to_a.should respond_to(:append_indented)
  end
end

