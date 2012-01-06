require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::FieldFilter do
  it "should construct events with matching fields" do
    filt = Wolverine::FieldFilter.
      new(source(["host pid: foo"]),
          /(\w+) (\w+): (.*)\Z/, :host, :pid, :msg)
    evt = filt.first
    evt.host.should == "host"
    evt.pid.should == "pid"
    evt.msg.should == "foo"
  end
  it "should construct events that raise errors for invalid field names" do
    filt = Wolverine::FieldFilter.
      new(source(["host pid: foo"]),
          /(\w+) (\w+): (.*)\Z/, :host, :pid, :msg)
    evt = filt.first
    lambda {
      evt.foo
    }.should raise_error
  end
  def source(ary)
    Wolverine::ArraySource.new(ary)
  end
end
