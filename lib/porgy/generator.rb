require 'porgy/intermediate'

require 'prawn'

module Porgy
  module Generator
    def self.generate(output, intermediate, style)
      Prawn::Document.generate(output, page_size: style.paper_size) do
        intermediate.blocks.each do |block|
          text block
        end
      end
    end
  end
end
