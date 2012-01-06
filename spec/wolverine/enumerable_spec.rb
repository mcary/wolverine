require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::Enumerable, "to_strings" do
  it "should convert contents to strings" do
    Class.new(Wolverine::Enumerable) do
      def each(&block)
        [1, 2].each(&block)
      end
    end.new.to_strings.should == ["1", "2"]
  end
end

