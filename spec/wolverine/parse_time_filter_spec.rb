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
end


