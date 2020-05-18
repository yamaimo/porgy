require 'prawn/measurement_extensions'

module Porgy
  class Config
    class Style
      module PaperSize
        ISO_A0  = [841.mm, 1189.mm]
        ISO_A1  = [594.mm,  841.mm]
        ISO_A2  = [420.mm,  594.mm]
        ISO_A3  = [297.mm,  420.mm]
        ISO_A4  = [210.mm,  297.mm]
        ISO_A5  = [148.mm,  210.mm]
        ISO_A6  = [105.mm,  148.mm]
        ISO_A7  = [ 74.mm,  105.mm]
        ISO_A8  = [ 52.mm,   74.mm]
        ISO_A9  = [ 37.mm,   52.mm]
        ISO_A10 = [ 26.mm,   37.mm]

        ISO_B0  = [1000.mm, 1414.mm]
        ISO_B1  = [ 707.mm, 1000.mm]
        ISO_B2  = [ 500.mm,  707.mm]
        ISO_B3  = [ 353.mm,  500.mm]
        ISO_B4  = [ 250.mm,  353.mm]
        ISO_B5  = [ 176.mm,  250.mm]
        ISO_B6  = [ 125.mm,  176.mm]
        ISO_B7  = [  88.mm,  125.mm]
        ISO_B8  = [  63.mm,   88.mm]
        ISO_B9  = [  44.mm,   63.mm]
        ISO_B10 = [  31.mm,   44.mm]

        JIS_B0  = [1030.mm, 1456.mm]
        JIS_B1  = [ 728.mm, 1030.mm]
        JIS_B2  = [ 515.mm,  728.mm]
        JIS_B3  = [ 364.mm,  515.mm]
        JIS_B4  = [ 257.mm,  364.mm]
        JIS_B5  = [ 182.mm,  257.mm]
        JIS_B6  = [ 128.mm,  182.mm]
        JIS_B7  = [  91.mm,  128.mm]
        JIS_B8  = [  64.mm,   91.mm]
        JIS_B9  = [  45.mm,   64.mm]
        JIS_B10 = [  32.mm,   45.mm]

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

        Default = ISO_A4

        def self.get_paper_size(obj)
          paper_size = Default
          unless obj.nil?
            case obj
            when String
              paper_size = List[obj.downcase] || Default
            when Array
              if obj.size == 2
                # allow units such as [10.cm, 12.cm]
                width = eval(obj[0])
                height = eval(obj[1])
                if width > 0 && height > 0
                  paper_size = [width, height]
                end
              end
            end
          end
          paper_size
        end
      end
    end
  end
end
