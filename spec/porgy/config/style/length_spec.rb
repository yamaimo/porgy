RSpec.describe Porgy::Config::Style::Length do
  describe ".load()" do
    it "returns the evaluated value of the givin string (with unit)" do
      expect(subject.class.load("10.cm")).to eq 10.cm
    end

    it "returns the evaluated value of the givin string (without unit)" do
      expect(subject.class.load("10")).to eq 10.pt
    end

    it "returns the number itself if a number is passed" do
      expect(subject.class.load(10)).to eq 10
    end

    it "returns 0 if no object is passed" do
      expect(subject.class.load(nil)).to eq 0
    end

    it "returns the specified default value if no object is passed" do
      expect(subject.class.load(nil, 1)).to eq 1
    end

    it "raises an error if an invalid string are passed" do
      expect{subject.class.load("invalid")}.to raise_error NameError
    end
  end
end
