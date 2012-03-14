require File.dirname(__FILE__)+"/../spec_helper"
describe Wolverine::FileSink do
  it "should write events to a file" do
    tmpfile = "spec.#{$$}.tmp"
    sink = Wolverine::FileSink.new(Wolverine::ArraySource.new(%w{x}), tmpfile)
    begin
      sink.run
      File.read(tmpfile).should == "x"
    ensure
      File.unlink tmpfile
    end
  end
end
