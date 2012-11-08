class Wolverine::Event
  attr_reader :text
  def initialize(text)
    @text = text
  end
  def <=>(other)
    to_s <=> other.to_s
  end
  def to_s
    @text
  end
end
