require 'porgy/config/style/paper_size.rb'

module Porgy
  class Config
    class Style
      def initialize(data)
        @name = data['name']
        @paper_size = PaperSize.get_paper_size(data['paper_size'])
      end

      attr_reader :name, :paper_size
    end
  end
end
