require 'porgy/config/style/paper_size'
require 'porgy/config/style/paper_margin'

module Porgy
  class Config
    class Style
      def initialize(data)
        @name = data['name']
        @paper_size = PaperSize.get_paper_size(data['paper_size'])
        @paper_margin = PaperMargin.get_paper_margin(data['paper_margin'])
      end

      attr_reader :name, :paper_size, :paper_margin
    end
  end
end
