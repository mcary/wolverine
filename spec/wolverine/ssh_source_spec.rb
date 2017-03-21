require File.dirname(__FILE__)+"/../spec_helper"
require "tempfile"
describe Wolverine::SshSource do
  it "should iterate through lines" do
    ary = []
    Tempfile.open("wol-spec") do |file|
      file.write("foo\nbar\n")
      file.flush
      src = Wolverine::SshSource.new "localhost", file.path
      ary = src.to_strings
    end

    ary.should == ["foo\n", "bar\n"]
  end
  it "should include unterminated final line" do
    ary = []
    Tempfile.open("wol-spec") do |file|
      file.write("foo")
      file.flush
      src = Wolverine::SshSource.new "localhost", file.path
      ary = src.to_strings
    end

    ary.should == ["foo"]
  end
  it "should unzip a file ending in .gz" do
    ary = []
    tmpfile = "rspec.#{$$}.tmp.gz"
    tmpfile = File.expand_path tmpfile, __dir__
    begin
      `echo hi | gzip > #{tmpfile}`
      src = Wolverine::SshSource.new "localhost", tmpfile
      ary = src.to_strings
      ary.should == ["hi\n"]
    ensure
      File.unlink tmpfile
    end
  end
end


