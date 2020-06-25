RSpec.describe Porgy::Config::Style::PaperSize do
  subject { Porgy::Config::Style::PaperSize.new(10.cm, 20.cm) }
  it { is_expected.to have_attributes width: 10.cm, height: 20.cm }

  describe ".load()" do
    it "returns the default paper size if no object is passed" do
      expect(subject.class.load(nil)).to be subject.class.default
    end

    it "returns the paper margin specified by a string" do
      data = "JIS B5"
      paper_size = subject.class.load(data)
      expect(paper_size).to eq Porgy::Config::Style::PaperSize::JIS_B5
    end

    it "returns the paper margin specified by a hash" do
      data = YAML.load <<~END_OF_DATA
        height: 210.mm
        width: 148.mm
      END_OF_DATA
      paper_size = subject.class.load(data)
      expect(paper_size).to have_attributes height: 210.mm, width: 148.mm
    end

    it "uses the default size if no specified" do
      data = YAML.load <<~END_OF_DATA
        width: 20.cm
      END_OF_DATA
      paper_size = subject.class.load(data)
      expect(paper_size).to have_attributes height: subject.class.default.height
    end
  end

  describe "#to_prawn" do
    subject { Porgy::Config::Style::PaperSize.new(15.cm, 25.cm).to_prawn }
    it { is_expected.to eq({page_size: [15.cm, 25.cm]}) }
  end
end
