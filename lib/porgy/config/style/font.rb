require 'porgy/config/style/length'

module Porgy
  class Config
    class Style
      class Font
        def initialize(name, style, size)
          @name = name
          @style = style
          @size = size
        end

        attr_reader :name, :style, :size

        Default = Font.new('', 'normal', 10.pt)

        def self.get_font(obj)
          font = Default
          unless obj.nil?
            name = obj['name'] || Default.name
            style = obj['style'] || Default.style
            size = Style::Length.load(obj['size'], Default.size)
            font = Font.new(name, style, size)
          end
          font
        end
      end
    end
  end
end
