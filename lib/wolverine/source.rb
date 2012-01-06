class Wolverine::Source
  include Enumerable
  def each(&block)
    raise "abstract"
    yield event
  end
end
