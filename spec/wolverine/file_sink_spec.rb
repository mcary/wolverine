require File.dirname(__FILE__)+"/../spec_helper"
require "tempfile"
describe Wolverine::FileSink do
  it "should write events to a file" do
    Tempfile.open("wol-spec") do |file|
      tmpfile = file.path
      sink = Wolverine::FileSink.new(Wolverine::ArraySource.new(%w{x}), tmpfile)

      sink.run
      File.read(tmpfile).should == "x"
    end
  end
end
