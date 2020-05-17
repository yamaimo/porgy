require 'redcarpet'

module Porgy
  module Parser
    class MarkdownParser
      def self.parse(documents)
        redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        htmls = documents.map do |document|
          markdown = File.read(document)
          redcarpet.render(markdown)
        end
        htmls.join("\n")
      end
    end
  end
end

