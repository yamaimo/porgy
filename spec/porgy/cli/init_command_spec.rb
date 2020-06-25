RSpec.describe Porgy::CLI::InitCommand do
  it { is_expected.to have_attributes name: 'init' }
  it { is_expected.to have_attributes description: 'Initialize a porgy project.' }

  describe "#run()" do
    context "with specifying documents and scripts" do
      it "sets up a project" do
        args = ["hoge.md", "huga.md", "piyo.rb"]
        expect(Porgy::Project).to receive(:setup).with(Pathname.pwd, ["hoge.md", "huga.md"], ["piyo.rb"])
        subject.run(args)
      end
    end

    context "with specifying directory" do
      it "sets up a project" do
        args = ["foo/bar"]
        expect(Porgy::Project).to receive(:setup).with(Pathname.pwd+"foo/bar", ["bar.md"], ["bar.rb"])
        subject.run(args)
      end
    end

    context "with invalid args" do
      it "prints usage and exit" do
        allow(Porgy::Project).to receive(:setup)

        expect(subject).to receive(:exit_with_usage).with('Invalid syntax.')
        subject.run(["hoge", "huga"]) rescue "" # ignore error
      end
    end

    context "with '-h' or '--help'" do
      it "prints help" do
        allow(Porgy::Project).to receive(:setup)

        expect(subject).to receive(:exit_with_usage)
        subject.run(["-h"]) rescue "" # ignore error

        expect(subject).to receive(:exit_with_usage)
        subject.run(["--help"]) rescue "" # ignore error
      end
    end

    context "with invalid option" do
      it "raises an error" do
        expect{subject.run(["--dummy"])}.to raise_error
      end
    end
  end

  describe "#exit_with_usage()" do
    context "without message" do
      it "outputs usage and exits" do
        expect(subject).to receive(:exit).with(0)
        expect{subject.exit_with_usage}.to output(<<~END_OF_EXPECTED).to_stdout
          Usage(1): porgy init [<.md files>... [<.rb files>...]]
          Usage(2): porgy init <directory>

          Initialize a porgy project.

          (1) Make the current directory a porgy project.
              Rakefile and porgy.yml will be created.
              If any .md files (and .rb files) are specified, they will be set as source files.
              If Rakefile or porgy.yml already exists, this command will exit with an error.

          (2) Make the specified directory a porgy project.
              Rakefile, porgy.yml, <basename>.md, and <basename>.rb will be created in the directory.
              <basename>.md and <basename>.rb are set as source files.
        END_OF_EXPECTED
      end
    end

    context "with message" do
      it "outputs message and usage, and exits" do
        expect(subject).to receive(:exit).with(1)
        expect{subject.exit_with_usage("Error message.")}.to output(<<~END_OF_EXPECTED).to_stdout
          Error message.

          Usage(1): porgy init [<.md files>... [<.rb files>...]]
          Usage(2): porgy init <directory>

          Initialize a porgy project.

          (1) Make the current directory a porgy project.
              Rakefile and porgy.yml will be created.
              If any .md files (and .rb files) are specified, they will be set as source files.
              If Rakefile or porgy.yml already exists, this command will exit with an error.

          (2) Make the specified directory a porgy project.
              Rakefile, porgy.yml, <basename>.md, and <basename>.rb will be created in the directory.
              <basename>.md and <basename>.rb are set as source files.
        END_OF_EXPECTED
      end
    end
  end
end
