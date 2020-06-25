RSpec.describe Porgy::Parser::HtmlParser do
  describe ".parse()" do
    it "adds blocks into intermediate" do
      html = <<~END_OF_HTML
        <p>This is an example html.</p>
        <p>There are two paragraphs.</p>
      END_OF_HTML

      intermediate = double("Intermediate")
      expect(intermediate).to receive(:add_block).with('This is an example html.')
      expect(intermediate).to receive(:add_block).with('There are two paragraphs.')
      allow(Porgy::Intermediate).to receive(:new).and_return(intermediate)

      subject.class.parse(html)
    end
  end
end
