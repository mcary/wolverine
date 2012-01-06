class Wolverine::Event
  def initialize(text)
    @text = text
  end
  def to_s
    @text
  end
end
