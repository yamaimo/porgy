require 'porgy/cli/application'
require 'porgy/project'

require 'optparse'
require 'pathname'

module Porgy
  module CLI
    class InitCommand
      def initialize
        @name = 'init'
        @description = 'Initialize a porgy project.'
      end

      attr_reader :name, :description

      def run(args)
        parser = OptionParser.new
        options = parser.getopts(args, 'h', 'help')

        if options['h'] || options['help']
          exit_with_usage
        end

        dir, documents, scripts = parse_args(args)

        Porgy::Project.setup(dir, documents, scripts)
      end

      def exit_with_usage(error_message='')
        unless error_message.empty?
          puts error_message
          puts
        end

        puts <<~END_OF_USAGE
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
        END_OF_USAGE

        exit(error_message.empty? ? 0 : 1)
      end

      private

      def parse_args(args)
        dir = Pathname.pwd
        documents = []
        scripts = []

        unless args.empty?
          documents = args.select{|s| s.downcase.end_with?('.md')}
          scripts = args.select{|s| s.downcase.end_with?('.rb')}
          if documents.empty?
            if scripts.empty? && args.size == 1
              dir += args[0]
              basename = dir.basename
              documents.push "#{basename}.md"
              scripts.push "#{basename}.rb"
            else
              exit_with_usage('Invalid syntax.')
            end
          end
        end

        [dir, documents, scripts]
      end
    end
  end
end

Porgy::CLI.application.add_subcommand(Porgy::CLI::InitCommand.new)
