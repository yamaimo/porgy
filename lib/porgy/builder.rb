require 'porgy/config'
require 'porgy/parser'
require 'porgy/generator'

module Porgy
  module Builder
    def self.rakefile_template
      <<~END_OF_RAKEFILE
        require 'porgy'

        require 'pathname'

        porgy_file = Pathname.new(__dir__) + 'porgy.yml'
        config = Porgy::Config.load(porgy_file)

        config.targets.each do |target|
          namespace :build_ do
            task target.name => [target.output]
            file target.output => (target.sources + [__FILE__, porgy_file]) do
              Porgy::Builder.build(target.name, config)
            end
          end
        end

        desc "Build target [target=\#{config.target_names.join('|')} (default=\#{config.default_target})]"
        task :build, [:target] do |task, args|
          target_name = args[:target] || config.default_target
          Rake::Task["build_:\#{target_name}"].invoke
        end
      END_OF_RAKEFILE
    end

    def self.build(target_name, config)
      target = config.find_target(target_name)
      style = config.find_style(target.style)

      intermediate = Porgy::Parser.parse(target.documents)
      Porgy::Generator.generate(target.output, intermediate, style, config)
    end
  end
end
