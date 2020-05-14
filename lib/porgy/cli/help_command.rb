module Porgy
  module CLI
    class HelpCommand
      def initialize
        @name = 'help'
        @description = 'Display help.'
      end

      attr_reader :name, :description

      def run(args)
        application = Porgy::CLI.application

        if args.empty?
          application.exit_with_usage
        end

        command_name = args.shift
        command = application.subcommands[command_name]
        if command.nil?
          application.exit_with_usage("Command '#{command_name}' is invalid.")
        end

        command.exit_with_usage
      end

      def exit_with_usage(error_message='')
        unless error_message.empty?
          puts error_message
          puts
        end

        # not yet
        puts <<~END_OF_USAGE
          Usage: porgy help <command>

          Display help for <command>.
        END_OF_USAGE

        exit(error_message.empty? ? 0 : 1)
      end
    end
  end
end

Porgy::CLI.application.add_subcommand(Porgy::CLI::HelpCommand.new)
