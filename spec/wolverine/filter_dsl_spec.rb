require File.dirname(__FILE__)+"/../spec_helper"
include Wolverine
describe Wolverine::FileSource do
  it "should nest filters" do
    filt = ArraySource.new(["foo", "  bar"]).append_indented
    filt.count.should == 1
  end
  it "should evaluate lazily" do
    class ExceptionalSource < Source
      def each
        raise Exception, "Called 'each'"
      end
    end
    lambda {
      src = ExceptionalSource.new.append_indented
    }.should_not raise_error
    lambda {
      src.to_a
    }.should raise_error
  end
  it "should accept where.not(conditions)" do
    Source.new.where.not(:foo => "bar").head(10)
  end
  it "should not accept where(conditions).not" do
    lambda {
      Source.new.where(:foo => "bar").not
    }.should raise_error(NoMethodError)
  end
end
