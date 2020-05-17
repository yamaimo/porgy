require 'porgy/intermediate'

require 'prawn'

module Porgy
  module Generator
    def self.generate(output, intermediate)
      Prawn::Document.generate(output) do
        intermediate.blocks.each do |block|
          text block
        end
      end
    end
  end
end
