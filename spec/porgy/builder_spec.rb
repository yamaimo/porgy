RSpec.describe Porgy::Builder do
  describe ".build()" do
    it "parses documents and generates pdf" do
      target = double("target")
      allow(target).to receive(:style)
      allow(target).to receive(:documents)
      allow(target).to receive(:output)

      config = double("configuration")
      allow(config).to receive(:find_target).and_return(target)
      allow(config).to receive(:find_style)

      expect(Porgy::Parser).to receive(:parse)
      expect(Porgy::Generator).to receive(:generate)

      Porgy::Builder.build(nil, config)
    end
  end
end
