RSpec.describe Porgy::Config::Font do
  describe Porgy::Config::Font::Mode do
    subject { Porgy::Config::Font::Mode.new("normal", "ipaexm.ttf", 0) }
    it { is_expected.to have_attributes name: "normal", file: Pathname.new("ipaexm.ttf"), index: 0 }

    describe ".load()" do
      let(:font_name) { "dummy" }

      it "returns the font mode specified by a hash" do
        data = YAML.load <<~END_OF_DATA
          name: bold
          file: ipaexg.ttf
        END_OF_DATA
        font_mode = subject.class.load(font_name, data)
        expect(font_mode).to have_attributes name: "bold", file: Pathname.new("ipaexg.ttf"), index: nil
      end

      it "raises an error if no name is specified" do
        data = YAML.load <<~END_OF_DATA
          file: LoveLetter.TTF
        END_OF_DATA
        expect{subject.class.load(font_name, data)}.to raise_error "Mode has no name."
      end

      it "raises an error if no file is specified" do
        data = YAML.load <<~END_OF_DATA
          name: bold_italic
        END_OF_DATA
        expect{subject.class.load(font_name, data)}.to raise_error "Font file is not specified. (font: dummy, mode: bold_italic)"
      end
    end
  end

  let(:normal_mode) { Porgy::Config::Font::Mode.new("normal", Pathname.new("ipaexm.ttf"), nil) }
  let(:bold_mode) { Porgy::Config::Font::Mode.new("bold", Pathname.new("ipaexg.ttf"), nil) }
  subject { Porgy::Config::Font.new("ipaex", [normal_mode, bold_mode]) }

  it { is_expected.to have_attributes name: "ipaex", modes: [normal_mode, bold_mode] }

  describe ".load()" do
    it "returns the font specified by a hash" do
      data = YAML.load <<~END_OF_DATA
        name: sample
        modes:
          - name: normal
            file: sample.ttf
          - name: bold
            file: sample_bold.ttf
      END_OF_DATA
      font = subject.class.load(data)
      expect(font).to have_attributes name: "sample"
      expect(font.modes.size).to eq 2
      expect(font.modes[0].is_a? Porgy::Config::Font::Mode).to be_truthy
      expect(font.modes[1].is_a? Porgy::Config::Font::Mode).to be_truthy
    end

    it "raises an error if no name is specified" do
      data = YAML.load <<~END_OF_DATA
        modes:
          - name: normal
            file: dummy.ttf
      END_OF_DATA
      expect{subject.class.load(data)}.to raise_error "Font has no name."
    end

    it "raises an error if no mode is specified" do
      data = YAML.load <<~END_OF_DATA
        name: dummy
      END_OF_DATA
      expect{subject.class.load(data)}.to raise_error "Font 'dummy' has no mode."
    end
  end

  describe ".find_path()" do
    it "searches the path from current working directory" do
      font_data_dir = FileSupport.get_data_path('font')
      Dir.chdir(font_data_dir) do
        expect(subject.class.find_path(Pathname.new('dummy.ttf'))).to eq (font_data_dir + 'dummy.ttf')
      end
    end

    it "searches the path from system font libraries" do
      system_font_paths = Pathname.new('/System/Library/Fonts').glob('*.ttf')
      if system_font_paths.empty?
        system_font_paths = Pathname.new('/Library/Fonts').glob('*.ttf')
      end
      skip if system_font_paths.empty?

      system_font_path = system_font_paths[0]
      system_font_name = system_font_path.basename
      expect(subject.class.find_path(system_font_name)).to eq system_font_path
    end

    it "searches the absolute path" do
      absolute_path = FileSupport.get_data_path('font/dummy.ttf')
      expect(subject.class.find_path(absolute_path)).to eq absolute_path
    end

    it "raises an error if no path is found" do
      expect{subject.class.find_path(Pathname.new('not_found.ttf'))}.to raise_error "Font file 'not_found.ttf' is not found."
    end
  end

  describe "#register()" do
    before do
      # replace '.find_path()' to avoid file not found
      ipaexm_path = Pathname.new('ipaexm.ttf')
      ipaexg_path = Pathname.new('ipaexg.ttf')
      allow(Porgy::Config::Font).to receive(:find_path).with(ipaexm_path).and_return(ipaexm_path)
      allow(Porgy::Config::Font).to receive(:find_path).with(ipaexg_path).and_return(ipaexg_path)
    end

    it "registers the font to the document" do
      document = double('Document mock')
      font_settings = Hash.new
      expect(document).to receive(:font_families).and_return(font_settings)

      subject.register(document)

      prawn_data = {
        normal: 'ipaexm.ttf',
        bold: 'ipaexg.ttf',
      }
      expect(font_settings.keys).to include('ipaex')
      expect(font_settings['ipaex']).to eq prawn_data
    end

    it "won't register the font to the same document again" do
      document = double('Document mock')
      expect(document).to receive(:font_families).and_return(Hash.new)

      subject.register(document)

      expect(document).not_to receive(:font_families)

      subject.register(document)
    end

    it "registers the font to another document" do
      document = double('Document mock')
      expect(document).to receive(:font_families).and_return(Hash.new)

      subject.register(document)

      another_document = double('Another document mock')
      expect(another_document).to receive(:font_families).and_return(Hash.new)

      subject.register(another_document)
    end
  end
end
