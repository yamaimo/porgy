require 'prawn/measurement_extensions'

module Porgy
  class Config
    class Style
      def self.eval_length(str, default=0)
        eval(str) || default
      end
    end
  end
end
