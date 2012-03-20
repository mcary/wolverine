require File.dirname(__FILE__)+"/../spec_helper"
require "tempfile"
describe Wolverine::LessSink do
  it "should pipe events to the pager" do
    Tempfile.open("wol-spec") do |file|
      sink = Wolverine::LessSink.new(Wolverine::ArraySource.new(%w{y}))
      sink.stub!(:pager_command => "/bin/cat > #{file.path}")

      sink.run
      File.read(file.path).should == "y\n"
    end
  end
  it "should return nil to avoid irb spew" do
    sink = Wolverine::LessSink.new(Wolverine::ArraySource.new(%w{x}))
    sink.stub!(:pager_command => "/bin/cat > /dev/null")
    sink.run.should == nil
  end
end
