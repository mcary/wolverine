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
  # This edge case prevously broke at the multiple-assignment construct
  it "should construct events with a single matching field" do
    filt = Wolverine::FieldFilter.
      new(source(["host pid: foo"]),
          /(\w+)/, :host)
    evt = filt.first
    evt.host.should == "host"
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
  it "should preserve previously created fields" do
    filt = Wolverine::FieldFilter.
      new(source(["host pid: foo"]),
          /(\w+) (\w+):/, :host, :pid)
    filt = Wolverine::FieldFilter.
      new(filt,
          /: (.*)\Z/, :msg)
    evt = filt.first
    evt.host.should == "host"
    evt.pid.should == "pid"
    evt.msg.should == "foo"
  end
  it "should return nil not raise when accessing unmatched fields" do
    filt = Wolverine::FieldFilter.
      new(source([" "]), /(\w+)/, :host)
    evt = filt.first
    evt.host.should == nil
  end
  def source(ary)
    Wolverine::ArraySource.new(ary)
  end
end
