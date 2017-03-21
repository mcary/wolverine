require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::CompatibilityGenerator do
  it "enumerates values yielded by #each" do
    gen = Wolverine::CompatibilityGenerator.new([1, 2, 3])
    [gen.next, gen.next, gen.next].should == [1, 2, 3]
  end
  it "gives warning of termination with #end?" do
    gen = Wolverine::CompatibilityGenerator.new([:item])
    expect {
      gen.next
    }.to change {
      gen.end?
    }.from(false).to(true)
  end
  it "returns the former result of #current from #next" do
    gen = Wolverine::CompatibilityGenerator.new([:item])
    cur = gen.current
    gen.next.should == cur
  end
end
