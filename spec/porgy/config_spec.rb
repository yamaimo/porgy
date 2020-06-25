# for mock
NamedObject = Struct.new(:name)
class NamedObject
  def self.array(base, size)
    size.times.map{|i| self.new("#{base}#{i}")}
  end
end

RSpec.describe Porgy::Config do
  let(:default_target) { "default" }
  let(:targets) { NamedObject.array('target', 3) }
  let(:styles) { NamedObject.array('style', 4) }
  let(:fonts) { NamedObject.array('font', 5) }

  subject { Porgy::Config.new(default_target, targets, styles, fonts) }

  it { is_expected.to have_attributes default_target: default_target }
  it { is_expected.to have_attributes targets: targets }
  it { is_expected.to have_attributes styles: styles }
  it { is_expected.to have_attributes fonts: fonts }

  describe ".load()" do
    before do
      # replace submodules to mocks
      allow(Porgy::Config::Target).to receive(:load).and_return(*NamedObject.array('target', 3))
      allow(Porgy::Config::Style).to receive(:load).and_return(*NamedObject.array('style', 4))
      allow(Porgy::Config::Font).to receive(:load).and_return(*NamedObject.array('font', 5))
    end

    it "returns the config specified by a config file" do
      config_file = FileSupport.get_data_path('config/porgy.yml')
      config = subject.class.load(config_file)
      expect(config).to have_attributes default_target: 'all'
      expect(config).to have_attributes targets: NamedObject.array('target', 3)
      expect(config).to have_attributes styles: NamedObject.array('style', 4)
      expect(config).to have_attributes fonts: NamedObject.array('font', 5)
    end
  end

  describe "#target_names()" do
    it "returns target names" do
      expect(subject.target_names).to eq ['target0', 'target1', 'target2']
    end
  end

  describe "#find_target()" do
    it "returns the specified target if exist" do
      expect(subject.find_target('target2')).to eq targets[2]
    end

    it "raises an error if not exist" do
      expect{subject.find_target('target3')}.to raise_error "Target 'target3' is not found."
    end
  end

  describe "#find_style()" do
    it "returns the specified style if exist" do
      expect(subject.find_style('style3')).to eq styles[3]
    end

    it "raises an error if not exist" do
      expect{subject.find_style('style4')}.to raise_error "Style 'style4' is not found."
    end
  end

  describe "#find_font()" do
    it "returns the specified font if exist" do
      expect(subject.find_font('font4')).to eq fonts[4]
    end

    it "raises an error if not exist" do
      expect{subject.find_font('font5')}.to raise_error "Font 'font5' is not found."
    end
  end
end
