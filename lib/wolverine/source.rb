class Wolverine::Source
  def each(&block)
    raise "abstract"
    yield event
  end
end
