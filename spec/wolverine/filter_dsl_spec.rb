require File.dirname(__FILE__)+"/../spec_helper"
include Wolverine
describe Wolverine::FileSource do
  it "should nest filters" do
    filt = ArraySource.new(["foo", "  bar"]).append_indented.count
    ary = filt.to_a
    ary.first.to_s.should == "1"
    ary.size.should == 1
  end
  it "should evaluate lazily" do
    class ExceptionalSource < Source
      def each
        raise Exception, "Called 'each'"
      end
    end
    lambda {
      src = ExceptionalSource.new.append_indented.count
    }.should_not raise_error
    lambda {
      src.to_a
    }.should raise_error
  end
end
