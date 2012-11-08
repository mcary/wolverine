require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::ParseTimeFilter do
  it "should parse a time from a log message" do
    filt = Wolverine::ParseTimeFilter.new(
      Wolverine::ArraySource.new(["2012-01-01 08:00:00.042"]),
      :to_s, :ts
    )
    ts = filt.first.ts
    ts.year.should == 2012
    ts.usec.should == 42_000
    ts.hour.should == 8
  end
  it "should define <=> on the events it produces" do
    filt = Wolverine::ParseTimeFilter.new(
      Wolverine::ArraySource.new([
        "2012-01-01 08:00:00.042",
        "2012-01-01 08:00:00.043",
      ]),
      :to_s, :ts
    )
    evt = filt.first
    evt2 = filt.to_a.last
    (evt <=> evt2).should == -1
  end
  it "should define <=> sort nil times first" do
    filt = Wolverine::ParseTimeFilter.new(
      Wolverine::ArraySource.new([
        "2012-01-01 08:00:00.042",
        nil,
      ]),
      :to_s, :ts
    )
    evt = filt.first
    evt2 = filt.to_a.last
    evt2.ts.should == nil
    (evt <=> evt2).should == 1
    (evt2 <=> evt).should == -1
    (evt2 <=> evt2).should == 0
  end
end


