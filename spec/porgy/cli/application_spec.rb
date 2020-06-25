RSpec.describe Porgy::CLI::Application do
  describe "Porgy::CLI.application()" do
    it "returns the same application object" do
      app = Porgy::CLI.application
      expect(app).to be_instance_of(Porgy::CLI::Application)
      expect(Porgy::CLI.application).to be app
    end
  end

  let(:sub1) do
    subcommand = double("subcommand 1")
    allow(subcommand).to receive(:name).and_return("subcommand1")
    allow(subcommand).to receive(:description).and_return("subcommand 1.")
    subcommand
  end
  let(:sub2) do
    subcommand = double("subcommand 2")
    allow(subcommand).to receive(:name).and_return("subcommand2")
    allow(subcommand).to receive(:description).and_return("subcommand 2.")
    subcommand
  end
  let(:help) do
    subcommand = double("help")
    allow(subcommand).to receive(:name).and_return("help")
    allow(subcommand).to receive(:description).and_return("help.")
    subcommand
  end

  subject { Porgy::CLI::Application.new }

  it { is_expected.to have_attributes subcommands: {} }

  describe "#run()" do
    before do
      subject.add_subcommand(sub1)
      subject.add_subcommand(sub2)
      subject.add_subcommand(help)
    end

    it "executes the specified subcommand" do
      args = ["subcommand1", "arg1", "arg2"]
      expect(sub1).to receive(:run).with(["arg1", "arg2"])
      subject.run(args)
    end

    it "prints help for '-h', '--help', or 'help'" do
      expect(help).to receive(:run)
      subject.run(["-h"])

      expect(help).to receive(:run)
      subject.run(["--help"])

      expect(help).to receive(:run)
      subject.run(["help"])
    end

    it "prints version and exits for '-v' or '--version'" do
      allow(subject).to receive(:exit_with_usage)

      expect(subject).to receive(:exit).with(0)
      expect{subject.run(["-v"])}.to output(Porgy::VERSION).to_stdout rescue "" # ignore error

      expect(subject).to receive(:exit).with(0)
      expect{subject.run(["--version"])}.to output(Porgy::VERSION).to_stdout rescue "" # ignore error
    end

    it "raises an error if an invalid option is specified" do
      expect{subject.run(["--dummy"])}.to raise_error
    end

    it "exits with error if no subcommand is specified" do
      allow(subject).to receive(:exit_with_usage)
      expect(subject).to receive(:exit_with_usage).with("No command is specified.")
      subject.run([]) rescue "" # ignore error
    end

    it "exits with error if non-exist subcommand is specified" do
      allow(subject).to receive(:exit_with_usage)
      expect(subject).to receive(:exit_with_usage).with("Command 'dummy' is invalid.")
      subject.run(["dummy"]) rescue "" # ignore error
    end
  end

  describe "#exit_with_usage()" do
    before do
      subject.add_subcommand(sub1)
      subject.add_subcommand(sub2)
    end

    context "without message" do
      it "outputs usage and exits" do
        expect(subject).to receive(:exit).with(0)
        expect{subject.exit_with_usage}.to output(<<~END_OF_EXPECTED).to_stdout
          Usage: porgy [-h|-v|--help|--version] <command> <args>...

          Easy PDF Writer.

          Options:
            -h, --help      Display help.
            -v, --version   Display version.

          Commands:
            subcommand1\t\tsubcommand 1.
            subcommand2\t\tsubcommand 2.
        END_OF_EXPECTED
      end
    end

    context "with message" do
      it "outputs message and usage, and exits" do
        expect(subject).to receive(:exit).with(1)
        expect{subject.exit_with_usage("Error message.")}.to output(<<~END_OF_EXPECTED).to_stdout
          Error message.

          Usage: porgy [-h|-v|--help|--version] <command> <args>...

          Easy PDF Writer.

          Options:
            -h, --help      Display help.
            -v, --version   Display version.

          Commands:
            subcommand1\t\tsubcommand 1.
            subcommand2\t\tsubcommand 2.
        END_OF_EXPECTED
      end
    end
  end

  describe "#add_subcommand()" do
    it "adds subcommand" do
      expect{subject.add_subcommand(sub1)}.to change{subject.subcommands.size}.from(0).to(1)
      expect{subject.add_subcommand(sub2)}.to change{subject.subcommands.size}.from(1).to(2)
      expect{subject.add_subcommand(sub1)}.not_to change{subject.subcommands.size}
    end
  end
end
