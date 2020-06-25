RSpec.describe Porgy::Config::Target do
  let(:name) { "test" }
  let(:documents) { ["test1.md", "test2.md"] }
  let(:scripts) { ["test1.rb", "test2.rb", "test3.rb"] }
  let(:output) { "test.pdf" }
  let(:style) { "test_style" }

  subject { Porgy::Config::Target.new(name, documents, scripts, output, style) }

  it { is_expected.to have_attributes name: name }
  it { is_expected.to have_attributes documents: documents }
  it { is_expected.to have_attributes scripts: scripts }
  it { is_expected.to have_attributes output: output }
  it { is_expected.to have_attributes style: style }
  it { is_expected.to have_attributes sources: (documents + scripts) }

  describe ".load()" do
    it "returns the target specified by a hash" do
      data = YAML.load <<~END_OF_DATA
        name: sample
        documents:
          - sample.md
        scripts:
          - sample1.rb
          - sample2.rb
        output: sample.pdf
        style: sample_style
      END_OF_DATA
      target = subject.class.load(data)
      expect(target).to have_attributes name: "sample"
      expect(target).to have_attributes documents: ["sample.md"]
      expect(target).to have_attributes scripts: ["sample1.rb", "sample2.rb"]
      expect(target).to have_attributes output: "sample.pdf"
      expect(target).to have_attributes style: "sample_style"
    end

    it "raises an error if no name is specified" do
      data = YAML.load <<~END_OF_DATA
        documents:
          - sample.md
        scripts:
          - sample1.rb
          - sample2.rb
        output: sample.pdf
        style: sample_style
      END_OF_DATA
      expect{subject.class.load(data)}.to raise_error "Target has no name."
    end

    it "raises an error if no document is specified" do
      data = YAML.load <<~END_OF_DATA
        name: sample
        scripts:
          - sample1.rb
          - sample2.rb
        output: sample.pdf
        style: sample_style
      END_OF_DATA
      expect{subject.class.load(data)}.to raise_error "Target 'sample' has no documents."
    end

    it "has empty scripts if no scripts is specified" do
      data = YAML.load <<~END_OF_DATA
        name: sample
        documents: [sample.md]
        output: sample.pdf
        style: sample_style
      END_OF_DATA
      expect(subject.class.load(data)).to have_attributes scripts: []
    end

    it "raises an error if no output is specified" do
      data = YAML.load <<~END_OF_DATA
        name: sample
        documents: [sample.md]
        style: sample_style
      END_OF_DATA
      expect{subject.class.load(data)}.to raise_error "Target 'sample' has no output."
    end

    it "raises an error if no output is specified" do
      data = YAML.load <<~END_OF_DATA
        name: sample
        documents: [sample.md]
        output: sample.pdf
      END_OF_DATA
      expect{subject.class.load(data)}.to raise_error "Target 'sample' has no style."
    end
  end
end
