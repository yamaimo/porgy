RSpec.describe Porgy::Parser do
  describe ".parse()" do
    it "calls markdown parser and html parser" do
      expect(Porgy::Parser::MarkdownParser).to receive(:parse)
      expect(Porgy::Parser::HtmlParser).to receive(:parse)

      markdown = FileSupport.get_data_path('markdown/sample.md')
      Porgy::Parser.parse(markdown)
    end
  end
end
