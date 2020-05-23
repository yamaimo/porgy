require 'porgy/intermediate'

require 'prawn'

module Porgy
  module Generator
    def self.generate(output, intermediate, style, config)
      page_size = style.paper_size.to_prawn
      page_margin = style.paper_margin.to_prawn
      Prawn::Document.generate(output, **page_size, **page_margin) do |document|
        font_name = style.font.name
        config.find_font(font_name).register(document)
        document.font font_name, style: style.font.style.to_s, size: style.font.size

        document.default_leading style.baseline_skip

        intermediate.blocks.each do |block|
          document.text block
        end
      end
    end
  end
end
