require 'porgy/config'
require 'porgy/parser'
require 'porgy/generator'

module Porgy
  module Builder
    def self.build(target_name, config)
      target = config.find_target(target_name)
      style = config.find_style(target.style)

      intermediate = Porgy::Parser.parse(target.documents)
      Porgy::Generator.generate(target.output, intermediate, style, config)
    end
  end
end
