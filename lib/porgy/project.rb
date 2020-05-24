require 'porgy/config'
require 'porgy/builder'

require 'fileutils'
require 'pathname'

module Porgy
  module Project
    def self.setup(dir, documents, scripts)
      self.make_dir(dir)
      self.output_rakefile(dir)
      self.output_config(dir, documents, scripts)
    end

    def self.make_dir(dir)
      FileUtils.makedirs(dir) unless dir.exist?
    end

    def self.output_rakefile(dir)
      dist = dir + 'Rakefile'
      raise 'Rakefile already exists.' if dist.exist?

      template = Porgy::Builder.rakefile_template
      File.write(dist, template)
    end

    def self.output_config(dir, documents, scripts)
      dist = dir + 'porgy.yml'
      raise 'porgy.yml already exists.' if dist.exist?

      template = Porgy::Config.porgy_yaml_template
      replaced = eval %("#{template}")
      File.write(dist, replaced)

      [documents, scripts].flatten.each do |file|
        path = dir + file
        FileUtils.touch(path) unless path.exist?
      end
    end
  end
end
