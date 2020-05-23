require 'prawn/measurement_extensions'

module Porgy
  class Config
    class Style
      class Length
        def self.load(str, default=0)
          eval(str) || default
        end
      end
    end
  end
end
