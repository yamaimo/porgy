require 'porgy/config/style/length'

module Porgy
  class Config
    class Style
      class PaperSize
        def self.default
          @default ||= ISO_A4
        end

        def self.load(data)
          paper_size = self.default
          unless data.nil?
            case data
            when String
              paper_size = List[data.downcase] || self.default
            when Hash
              width = Style::Length.load(data['width'])
              height = Style::Length.load(data['height'])
              if width > 0 && height > 0
                paper_size = PaperSize.new(width, height)
              end
            end
          end
          paper_size
        end

        def initialize(width, height)
          @width = width
          @height = height
        end

        attr_reader :width, :height

        def to_prawn
          {page_size: [@width, @height]}
        end

        # --- predefined sizes and name list --- #

        ISO_A0  = PaperSize.new(841.mm, 1189.mm)
        ISO_A1  = PaperSize.new(594.mm,  841.mm)
        ISO_A2  = PaperSize.new(420.mm,  594.mm)
        ISO_A3  = PaperSize.new(297.mm,  420.mm)
        ISO_A4  = PaperSize.new(210.mm,  297.mm)
        ISO_A5  = PaperSize.new(148.mm,  210.mm)
        ISO_A6  = PaperSize.new(105.mm,  148.mm)
        ISO_A7  = PaperSize.new( 74.mm,  105.mm)
        ISO_A8  = PaperSize.new( 52.mm,   74.mm)
        ISO_A9  = PaperSize.new( 37.mm,   52.mm)
        ISO_A10 = PaperSize.new( 26.mm,   37.mm)

        ISO_B0  = PaperSize.new(1000.mm, 1414.mm)
        ISO_B1  = PaperSize.new( 707.mm, 1000.mm)
        ISO_B2  = PaperSize.new( 500.mm,  707.mm)
        ISO_B3  = PaperSize.new( 353.mm,  500.mm)
        ISO_B4  = PaperSize.new( 250.mm,  353.mm)
        ISO_B5  = PaperSize.new( 176.mm,  250.mm)
        ISO_B6  = PaperSize.new( 125.mm,  176.mm)
        ISO_B7  = PaperSize.new(  88.mm,  125.mm)
        ISO_B8  = PaperSize.new(  63.mm,   88.mm)
        ISO_B9  = PaperSize.new(  44.mm,   63.mm)
        ISO_B10 = PaperSize.new(  31.mm,   44.mm)

        JIS_B0  = PaperSize.new(1030.mm, 1456.mm)
        JIS_B1  = PaperSize.new( 728.mm, 1030.mm)
        JIS_B2  = PaperSize.new( 515.mm,  728.mm)
        JIS_B3  = PaperSize.new( 364.mm,  515.mm)
        JIS_B4  = PaperSize.new( 257.mm,  364.mm)
        JIS_B5  = PaperSize.new( 182.mm,  257.mm)
        JIS_B6  = PaperSize.new( 128.mm,  182.mm)
        JIS_B7  = PaperSize.new(  91.mm,  128.mm)
        JIS_B8  = PaperSize.new(  64.mm,   91.mm)
        JIS_B9  = PaperSize.new(  45.mm,   64.mm)
        JIS_B10 = PaperSize.new(  32.mm,   45.mm)

        List = {
          'a0'  => ISO_A0,
          'a1'  => ISO_A1,
          'a2'  => ISO_A2,
          'a3'  => ISO_A3,
          'a4'  => ISO_A4,
          'a5'  => ISO_A5,
          'a6'  => ISO_A6,
          'a7'  => ISO_A7,
          'a8'  => ISO_A8,
          'a9'  => ISO_A9,
          'a10' => ISO_A10,

          'b0'  => ISO_B0,
          'b1'  => ISO_B1,
          'b2'  => ISO_B2,
          'b3'  => ISO_B3,
          'b4'  => ISO_B4,
          'b5'  => ISO_B5,
          'b6'  => ISO_B6,
          'b7'  => ISO_B7,
          'b8'  => ISO_B8,
          'b9'  => ISO_B9,
          'b10' => ISO_B10,

          'iso a0'  => ISO_A0,
          'iso a1'  => ISO_A1,
          'iso a2'  => ISO_A2,
          'iso a3'  => ISO_A3,
          'iso a4'  => ISO_A4,
          'iso a5'  => ISO_A5,
          'iso a6'  => ISO_A6,
          'iso a7'  => ISO_A7,
          'iso a8'  => ISO_A8,
          'iso a9'  => ISO_A9,
          'iso a10' => ISO_A10,

          'iso b0'  => ISO_B0,
          'iso b1'  => ISO_B1,
          'iso b2'  => ISO_B2,
          'iso b3'  => ISO_B3,
          'iso b4'  => ISO_B4,
          'iso b5'  => ISO_B5,
          'iso b6'  => ISO_B6,
          'iso b7'  => ISO_B7,
          'iso b8'  => ISO_B8,
          'iso b9'  => ISO_B9,
          'iso b10' => ISO_B10,

          'jis b0'  => JIS_B0,
          'jis b1'  => JIS_B1,
          'jis b2'  => JIS_B2,
          'jis b3'  => JIS_B3,
          'jis b4'  => JIS_B4,
          'jis b5'  => JIS_B5,
          'jis b6'  => JIS_B6,
          'jis b7'  => JIS_B7,
          'jis b8'  => JIS_B8,
          'jis b9'  => JIS_B9,
          'jis b10' => JIS_B10,
        }
      end
    end
  end
end
