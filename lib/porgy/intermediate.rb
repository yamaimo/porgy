module Porgy
  class Intermediate
    def initialize
      @blocks = []
    end

    attr_reader :blocks

    def add_block(text)
      @blocks.push text
    end
  end
end
