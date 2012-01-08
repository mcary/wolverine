module Wolverine
  class HeadFilter < Filter
    attr_accessor :progress
    def initialize(source, limit, opts={})
      super(source)
      @limit = limit
      self.progress = opts[:progress]
    end
    def each
      progress = self.progress
      bar = ProgressBar.new("head(#{number_with_delimiter @limit})",
                            @limit) if progress
      cnt = 0
      @source.each do |evt|
        bar.set(cnt) if progress
        if cnt >= @limit
          bar.finish if progress
          return
        end
        yield evt
        cnt += 1
      end
    end
    # From Rails.
    def number_with_delimiter(number, delimiter=",")
        number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
    end
  end
end
