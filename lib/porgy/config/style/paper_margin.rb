require 'porgy/config/style/length'

module Porgy
  class Config
    class Style
      class PaperMargin
        def self.default
          @default ||= PaperMargin.new(0.5.in, 0.5.in, 0.5.in, 0.5.in)
        end

        def self.load(data)
          paper_margin = self.default
          unless data.nil?
            case data
            when String, Numeric
              length = Style::Length.load(data)
              if length > 0
                paper_margin = PaperMargin.new(length, length, length, length)
              end
            when Hash
              top = Style::Length.load(data['top'], self.default.top)
              right = Style::Length.load(data['right'], self.default.right)
              bottom = Style::Length.load(data['bottom'], self.default.bottom)
              left = Style::Length.load(data['left'], self.default.left)
              if top > 0 && right > 0 && bottom > 0 && left > 0
                paper_margin = PaperMargin.new(top, right, bottom, left)
              end
            end
          end
          paper_margin
        end

        def initialize(top, right, bottom, left)
          @top = top
          @right = right
          @bottom = bottom
          @left = left
        end

        attr_reader :top, :right, :bottom, :left

        def to_prawn
          {
            top_margin: @top,
            right_margin: @right,
            bottom_margin: @bottom,
            left_margin: @left,
          }
        end
      end
    end
  end
end
