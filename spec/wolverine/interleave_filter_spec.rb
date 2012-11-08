require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::InterleaveFilter do
  it "should interleave events" do
    filt = Wolverine::InterleaveFilter.new(
      Wolverine::ArraySource.new(%w{1 3 5}),
      Wolverine::ArraySource.new(%w{2 4})
    )
    filt.to_strings.should == %w{1 2 3 4 5}
  end
  it "should work with an empty source" do
    filt = Wolverine::InterleaveFilter.new(
      Wolverine::ArraySource.new(%w{1}),
      Wolverine::ArraySource.new([])
    )
    filt.to_strings.should == %w{1}
  end
  it "should work on an empty source" do
    filt = Wolverine::InterleaveFilter.new(
      Wolverine::ArraySource.new([]),
      Wolverine::ArraySource.new(%w{1})
    )
    filt.to_strings.should == %w{1}
  end
end


