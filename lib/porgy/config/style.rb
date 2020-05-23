require 'porgy/config/style/length'
require 'porgy/config/style/paper_size'
require 'porgy/config/style/paper_margin'
require 'porgy/config/style/font'

module Porgy
  class Config
    class Style
      def initialize(data)
        @name = data['name']
        @paper_size = PaperSize.get_paper_size(data['paper_size'])
        @paper_margin = PaperMargin.get_paper_margin(data['paper_margin'])
        @font = Font.get_font(data['font'])
        @baseline_skip = Length.load(data['baseline_skip'], 12.pt)
      end

      attr_reader :name, :paper_size, :paper_margin, :font, :baseline_skip
    end
  end
end
