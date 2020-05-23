require 'porgy/config/style/length'

module Porgy
  class Config
    class Style
      class PaperMargin
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

        Default = PaperMargin.new(0.5.in, 0.5.in, 0.5.in, 0.5.in)

        def self.get_paper_margin(obj)
          paper_margin = Default
          unless obj.nil?
            case obj
            when String
              length = Style::Length.load(obj)
              if length > 0
                paper_margin = PaperMargin.new(length, length, length, length)
              end
            when Hash
              top = Style::Length.load(obj['top'], Default.top)
              right = Style::Length.load(obj['right'], Default.right)
              bottom = Style::Length.load(obj['bottom'], Default.bottom)
              left = Style::Length.load(obj['left'], Default.left)
              if top > 0 && right > 0 && bottom > 0 && left > 0
                paper_margin = PaperMargin.new(top, right, bottom, left)
              end
            end
          end
          paper_margin
        end
      end
    end
  end
end
