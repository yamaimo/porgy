RSpec.describe Porgy::Project do
  describe ".setup()" do
    context "with exist directory" do
      it "set up project in the specified directory" do
        project_dir = FileSupport.get_output_dir('project/exist', clean: true)
        File.write(project_dir + "exist.md", "dummy")
        File.write(project_dir + "exist.rb", '"dummy"')

        Porgy::Project.setup(project_dir, ["exist.md"], ["exist.rb"])

        expect(project_dir).to be_exist
        expect(project_dir + "Rakefile").to be_exist
        expect(project_dir + "porgy.yml").to be_exist
        expect(File.read(project_dir + "exist.md").chomp).to eq "dummy"
        expect(File.read(project_dir + "exist.rb").chomp).to eq '"dummy"'
      end

      it "raises an error if Rakefile already exists." do
        project_dir = FileSupport.get_output_dir('project/rakefile_exist', clean: true)
        FileUtils.touch(project_dir + "Rakefile")

        expect{Porgy::Project.setup(project_dir, [], [])}.to raise_error "Rakefile already exists."
      end

      it "raises an error if Rakefile already exists." do
        project_dir = FileSupport.get_output_dir('project/config_exist', clean: true)
        FileUtils.touch(project_dir + "porgy.yml")

        expect{Porgy::Project.setup(project_dir, [], [])}.to raise_error "porgy.yml already exists."
      end
    end

    context "with non-exist directory" do
      it "set up project with creating the specified directory" do
        parent = FileSupport.get_output_dir('project/new_parent', clean: true)
        project_dir = parent + 'new'
        expect(project_dir).not_to be_exist

        Porgy::Project.setup(project_dir, ["new.md"], ["new.rb"])

        expect(project_dir).to be_exist
        expect(project_dir + "Rakefile").to be_exist
        expect(project_dir + "porgy.yml").to be_exist
        expect(project_dir + "new.md").to be_exist
        expect(project_dir + "new.rb").to be_exist
      end
    end
  end
end
