RSpec.describe Porgy::Config::Style::PaperMargin do
  subject { Porgy::Config::Style::PaperMargin.new(1.cm, 2.cm, 3.cm, 4.cm) }
  it { is_expected.to have_attributes top: 1.cm, right: 2.cm, bottom: 3.cm, left: 4.cm }

  describe ".load()" do
    it "returns the default paper margin if no object is passed" do
      expect(subject.class.load(nil)).to be subject.class.default
    end

    it "returns the paper margin whose top/right/bottom/left is specified length" do
      data = "2.cm"
      paper_margin = subject.class.load(data)
      expect(paper_margin).to have_attributes top: 2.cm, right: 2.cm, bottom: 2.cm, left: 2.cm
    end

    it "returns the paper margin specified by a hash" do
      data = YAML.load <<~END_OF_DATA
        top: 1.in
        bottom: 2.in
        left: 3.in
        right: 4.in
      END_OF_DATA
      paper_margin = subject.class.load(data)
      expect(paper_margin).to have_attributes top: 1.in, bottom: 2.in, left: 3.in, right: 4.in
    end

    it "uses the default size if no specified" do
      data = YAML.load <<~END_OF_DATA
        top: 23.mm
        bottom: 23.mm
      END_OF_DATA
      paper_margin = subject.class.load(data)
      expect(paper_margin).to have_attributes left: subject.class.default.left, right: subject.class.default.right
    end
  end

  describe "#to_prawn" do
    subject { Porgy::Config::Style::PaperMargin.new(1.pt, 2.pt, 3.pt, 4.pt).to_prawn }
    it { is_expected.to eq({top_margin: 1.pt, right_margin: 2.pt, bottom_margin: 3.pt, left_margin: 4.pt}) }
  end
end
