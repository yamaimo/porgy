require 'porgy/intermediate'

require 'prawn'

module Porgy
  module Generator
    def self.generate(output, intermediate, style)
      page_size = style.paper_size.to_prawn
      page_margin = style.paper_margin.to_prawn
      Prawn::Document.generate(output, **page_size, **page_margin) do
        intermediate.blocks.each do |block|
          text block
        end
      end
    end
  end
end
