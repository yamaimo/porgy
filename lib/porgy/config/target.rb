module Porgy
  class Config
    class Target
      def initialize(data)
        @name = data['name'] or raise "Target has no name."
        @documents = data['documents'] or raise "Target '#{@name}' has no documents."
        @scripts = data['scripts'] || []
        @output = data['output'] or raise "Target '#{@name}' has no output."
        @style = data['style'] or raise "Target '#{@name}' has no style."
      end

      attr_reader :name, :documents, :scripts, :output, :style

      def sources
        @documents + @scripts
      end
    end
  end
end
