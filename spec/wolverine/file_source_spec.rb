require File.dirname(__FILE__)+"/../spec_helper"
require "tempfile"
describe Wolverine::FileSource do
  it "should iterate through lines" do
    ary = []
    Tempfile.open("wol-spec") do |file|
      file.write("foo\nbar\n")
      file.flush
      src = Wolverine::FileSource.new file.path
      ary = src.map {|ev| ev.to_s}
    end

    ary.should == ["foo\n", "bar\n"]
  end
  it "should include unterminated final line" do
    ary = []
    Tempfile.open("wol-spec") do |file|
      file.write("foo")
      file.flush
      src = Wolverine::FileSource.new file.path
      ary = src.map {|ev| ev.to_s}
    end

    ary.should == ["foo"]
  end
end

