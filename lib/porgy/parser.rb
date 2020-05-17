require 'porgy/parser/markdown_parser'
require 'porgy/parser/html_parser'

module Porgy
  module Parser
    def self.parse(documents)
      html = Porgy::Parser::MarkdownParser.parse(documents)
      Porgy::Parser::HtmlParser.parse(html)
    end
  end
end
