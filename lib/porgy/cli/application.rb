require 'porgy/version'

require 'optparse'

module Porgy
  module CLI
    def self.application
      @application ||= Application.new
    end

    class Application
      def initialize
        @subcommands = Hash.new
      end

      attr_reader :subcommands

      def run(args)
        parser = OptionParser.new
        options = parser.getopts(args, 'hv', 'help', 'version')

        if options['h'] || options['help']
          args.unshift 'help' # set subcommand to 'help'
        end

        if options['v'] || options['version']
          puts Porgy::VERSION
          exit(0)
        end

        if args.empty?
          exit_with_usage('No command is specified.')
        end

        command_name = args.shift
        command = @subcommands[command_name]
        if command.nil?
          exit_with_usage("Command '#{command_name}' is invalid.")
        end

        command.run(args)
      end

      def exit_with_usage(error_message='')
        unless error_message.empty?
          puts error_message
          puts
        end

        puts <<~END_OF_USAGE
          Usage: porgy [-h|-v|--help|--version] <command> <args>...

          Easy PDF Writer.

          Options:
            -h, --help      Display help.
            -v, --version   Display version.

          Commands:
        END_OF_USAGE

        @subcommands.each do |name, command|
          puts "  #{name}\t\t#{command.description}"
        end

        exit(error_message.empty? ? 0 : 1)
      end

      def add_subcommand(command)
        @subcommands[command.name] = command
      end
    end
  end
end
