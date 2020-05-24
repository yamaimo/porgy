require 'porgy/config/style/length'

module Porgy
  class Config
    class Style
      class Font
        def self.default
          @default ||= Font.new('', 'normal', 10.pt)
        end

        def self.load(data)
          font = self.default
          unless data.nil?
            name = data['name'] || self.default.name
            mode = data['mode'] || self.default.mode
            size = Style::Length.load(data['size'], self.default.size)
            font = Font.new(name, mode, size)
          end
          font
        end

        def initialize(name, mode, size)
          @name = name
          @mode = mode
          @size = size
        end

        attr_reader :name, :mode, :size
      end
    end
  end
end
