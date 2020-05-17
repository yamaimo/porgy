require 'porgy/intermediate'

require 'ox'

module Porgy
  module Parser
    class HtmlParser
      def self.parse(html)
        intermediate = Porgy::Intermediate.new

        # add 'body' element as root
        html_body = "<body>#{html}</body>"

        dom = Ox.load(html_body)
        dom.each do |node|
          if node.value == 'p'
            intermediate.add_block node.text
          end
        end

        intermediate
      end
    end
  end
end
