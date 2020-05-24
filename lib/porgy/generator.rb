require 'porgy/intermediate'

require 'prawn'

module Porgy
  module Generator
    def self.generate(output, intermediate, style, config)
      options = {}
      options.update(style.paper_size.to_prawn)
      options.update(style.paper_margin.to_prawn)

      document = Prawn::Document.new(options)

      font_name = style.font.name
      config.find_font(font_name).register(document)
      document.font font_name, style: style.font.mode.to_s, size: style.font.size
      document.default_leading style.baseline_skip - style.font.size

      intermediate.blocks.each do |block|
        document.text block
      end

      document.render_file(output)
    end
  end
end
