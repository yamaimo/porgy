require 'porgy/config'

require 'prawn'

module Porgy
  class Builder
    def self.build(target_name, config)
      target = config.find_target(target_name)
      Prawn::Document.generate(target.output) do
        target.documents.each do |document|
          text File.read(document)
        end
      end
    end
  end
end
