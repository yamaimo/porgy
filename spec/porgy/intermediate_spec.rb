RSpec.describe Porgy::Intermediate do
  describe "#blocks()" do
    it "is initially empty" do
      intermediate = Porgy::Intermediate.new
      expect(intermediate.blocks).to be_empty
    end
  end

  describe "#add_block()" do
    it "adds block" do
      intermediate = Porgy::Intermediate.new

      intermediate.add_block("one")
      expect(intermediate.blocks).to eq ["one"]

      intermediate.add_block("another block")
      expect(intermediate.blocks).to eq ["one", "another block"]
    end
  end
end
