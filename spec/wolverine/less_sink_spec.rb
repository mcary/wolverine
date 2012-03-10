require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::LessSink do
  it "should pipe events to the pager" do
    tmpfile = "spec.#{$$}.tmp"
    sink = Wolverine::LessSink.new(Wolverine::ArraySource.new(%w{y}))
    sink.stub!(:pager_command => "/bin/cat > #{tmpfile}")
    begin
      sink.run
      File.read(tmpfile).should == "y\n"
    ensure
      File.unlink tmpfile
    end
  end
  it "should return nil to avoid irb spew" do
    sink = Wolverine::LessSink.new(Wolverine::ArraySource.new(%w{x}))
    sink.stub!(:pager_command => "/bin/cat > /dev/null")
    sink.run.should == nil
  end
end
