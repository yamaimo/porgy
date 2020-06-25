RSpec.describe Porgy::Parser::MarkdownParser do
  describe ".parse()" do
    it "converts markdown to html" do
      markdown = FileSupport.get_data_path('markdown/sample.md')
      expect(subject.class.parse([markdown])).to eq <<~END_OF_HTML
        <p>This is an example html.</p>

        <p>There are two paragraphs.</p>
      END_OF_HTML
    end
  end
end
