class Wolverine::CountFilter
  def initialize(source)
    @source = source
  end
  def each
    cnt = 0
    @source.each {|evt| cnt += 1 }
    yield cnt
  end
end
