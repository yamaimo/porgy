require 'prawn/measurement_extensions'

module Porgy
  class Config
    class Style
      class Length
        def self.load(data, default=0)
          eval(data.to_s) || default
        end
      end
    end
  end
end
