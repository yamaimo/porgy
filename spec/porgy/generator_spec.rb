RSpec.describe Porgy::Generator do
  describe ".generate()" do
    it "generates pdf with Prawn" do
      intermediate = double("intermediate")
      blocks = ["one", "two"]
      allow(intermediate).to receive(:blocks).and_return(blocks)

      style = double("style")
      allow(style).to receive_message_chain('paper_size.to_prawn').and_return(Hash.new)
      allow(style).to receive_message_chain('paper_margin.to_prawn').and_return(Hash.new)
      allow(style).to receive_message_chain('font.name')
      allow(style).to receive_message_chain('font.mode.to_sym')
      allow(style).to receive_message_chain('font.size').and_return(1)
      allow(style).to receive(:baseline_skip).and_return(2)

      config = double("config")
      allow(config).to receive_message_chain('find_font.register')

      document = double("document")
      expect(Prawn::Document).to receive(:new).and_return(document)
      expect(document).to receive(:font)
      expect(document).to receive(:default_leading)
      expect(document).to receive(:text).twice
      expect(document).to receive(:render_file)

      Porgy::Generator.generate(nil, intermediate, style, config)
    end
  end
end
