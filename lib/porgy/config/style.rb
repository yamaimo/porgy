require 'porgy/config/style/length'
require 'porgy/config/style/paper_size'
require 'porgy/config/style/paper_margin'
require 'porgy/config/style/font'

module Porgy
  class Config
    class Style
      def self.load(data)
        name = data['name'] or raise "Style has no name."
        paper_size = PaperSize.load(data['paper_size'])
        paper_margin = PaperMargin.load(data['paper_margin'])
        font = Font.load(data['font'])
        baseline_skip = Length.load(data['baseline_skip'], 12.pt)

        Style.new(name, paper_size, paper_margin, font, baseline_skip)
      end

      def initialize(name, paper_size, paper_margin, font, baseline_skip)
        @name = name
        @paper_size = paper_size
        @paper_margin = paper_margin
        @font = font
        @baseline_skip = baseline_skip
      end

      attr_reader :name, :paper_size, :paper_margin, :font, :baseline_skip
    end
  end
end
