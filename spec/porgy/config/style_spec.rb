RSpec.describe Porgy::Config::Style do
  let(:name) { "sample" }
  let(:paper_size) { Porgy::Config::Style::PaperSize.new(10.cm, 20.cm) }
  let(:paper_margin) { Porgy::Config::Style::PaperMargin.new(1.cm, 2.cm, 3.cm, 4.cm) }
  let(:font) { Porgy::Config::Style::Font.new("ipaex", "normal", 12.pt) }
  let(:baseline_skip) { 15.pt }

  subject { Porgy::Config::Style.new(name, paper_size, paper_margin, font, baseline_skip) }

  it { is_expected.to have_attributes name: name }
  it { is_expected.to have_attributes paper_size: paper_size }
  it { is_expected.to have_attributes paper_margin: paper_margin }
  it { is_expected.to have_attributes font: font }
  it { is_expected.to have_attributes baseline_skip: baseline_skip }

  describe ".load()" do
    before do
      # replace submodules to mocks
      allow(Porgy::Config::Style::PaperSize).to receive(:load).with('paper_size').and_return('paper_size')
      allow(Porgy::Config::Style::PaperMargin).to receive(:load).with('paper_margin').and_return('paper_margin')
      allow(Porgy::Config::Style::Font).to receive(:load).with('font').and_return('font')
      allow(Porgy::Config::Style::Length).to receive(:load).with('baseline_skip', 12.pt).and_return('baseline_skip')
    end

    it "returns the style specified by a hash" do
      data = YAML.load <<~END_OF_DATA
        name: sample
        paper_size: paper_size
        paper_margin: paper_margin
        font: font
        baseline_skip: baseline_skip
      END_OF_DATA
      style = subject.class.load(data)
      expect(style).to have_attributes name: 'sample'
      expect(style).to have_attributes paper_size: 'paper_size'
      expect(style).to have_attributes paper_margin: 'paper_margin'
      expect(style).to have_attributes font: 'font'
      expect(style).to have_attributes baseline_skip: 'baseline_skip'
    end

    it "raises an error if no name is specified" do
      data = YAML.load <<~END_OF_DATA
        paper_size: paper_size
        paper_margin: paper_margin
        font: font
        baseline_skip: baseline_skip
      END_OF_DATA
      expect{subject.class.load(data)}.to raise_error "Style has no name."
    end
  end
end
