RSpec.describe Porgy::CLI::HelpCommand do
  it { is_expected.to have_attributes name: 'help' }
  it { is_expected.to have_attributes description: 'Display help.' }

  describe "#run()" do
    context "with subcommand" do
      it "prints help for subcommand and exit" do
        init_command = Porgy::CLI.application.subcommands['init']
        expect(init_command).to receive(:exit_with_usage)
        subject.run(['init'])
      end
    end

    context "without subcommand" do
      it "prints porgy usage and exit" do
        allow(Porgy::CLI.application).to receive(:exit_with_usage)
        expect(Porgy::CLI.application).to receive(:exit_with_usage)
        subject.run([]) rescue "" # ignore error
      end
    end

    context "with non-exist subcommand" do
      it "prints porgy usage and exit" do
        subcommand = "dummy"
        allow(Porgy::CLI.application).to receive(:exit_with_usage)
        expect(Porgy::CLI.application).to receive(:exit_with_usage).with("Command 'dummy' is invalid.")
        subject.run([subcommand]) rescue "" # ignore error
      end
    end
  end

  describe "#exit_with_usage()" do
    context "without message" do
      it "outputs usage and exits" do
        expect(subject).to receive(:exit).with(0)
        expect{subject.exit_with_usage}.to output(<<~END_OF_EXPECTED).to_stdout
          Usage: porgy help <command>

          Display help for <command>.
        END_OF_EXPECTED
      end
    end

    context "with message" do
      it "outputs message and usage, and exits" do
        expect(subject).to receive(:exit).with(1)
        expect{subject.exit_with_usage("Error message.")}.to output(<<~END_OF_EXPECTED).to_stdout
          Error message.

          Usage: porgy help <command>

          Display help for <command>.
        END_OF_EXPECTED
      end
    end
  end
end
