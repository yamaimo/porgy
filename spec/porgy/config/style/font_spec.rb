RSpec.describe Porgy::Config::Style::Font do
  subject { Porgy::Config::Style::Font.new("ipaex", "normal", 10.pt) }
  it { is_expected.to have_attributes name: "ipaex", mode: "normal", size: 10.pt }

  describe ".load()" do
    it "returns the default font if no object is passed" do
      expect(subject.class.load(nil)).to be subject.class.default
    end

    it "returns the font object specified by a hash" do
      data = YAML.load <<~END_OF_DATA
        name: times
        mode: bold
        size: 12.pt
      END_OF_DATA
      font = subject.class.load(data)
      expect(font).to have_attributes name: "times", mode: "bold", size: 12.pt
    end

    it "uses the default font name if no name is specified" do
      data = YAML.load <<~END_OF_DATA
        mode: italic
        size: 1.cm
      END_OF_DATA
      font = subject.class.load(data)
      expect(font.name).to eq subject.class.default.name
    end

    it "uses the default font mode if no mode is specified" do
      data = YAML.load <<~END_OF_DATA
        name: helvetica
        size: 12.mm
      END_OF_DATA
      font = subject.class.load(data)
      expect(font.mode).to eq subject.class.default.mode
    end

    it "uses the default font size if no size is specified" do
      data = YAML.load <<~END_OF_DATA
        name: osaka
        mode: bold_italic
      END_OF_DATA
      font = subject.class.load(data)
      expect(font.size).to eq subject.class.default.size
    end
  end
end
