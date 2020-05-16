require 'yaml'

module Porgy
  class Config
    def self.load(file)
      data = YAML.load_file(file)
      Config.new(data)
    end

    def initialize(data)
      @default_target = data['default_target']
      @targets = data['targets'].map{|target_data| Target.new(target_data)}
      @styles = data['styles'].map{|style_data| Style.new(style_data)}
    end

    attr_reader :default_target, :targets, :styles

    def target_names
      @targets.map(&:name)
    end

    def find_target(name)
      found = @targets.filter{|target| target.name == name}
      raise "Traget '#{name}' is not found." if found.empty?
      found[0]
    end

    def find_style(name)
      found = @styles.filter{|style| style.name == name}
      raise "Style '#{name}' is not found." if found.empty?
      found[0]
    end

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

    class Style
      def initialize(data)
        @name = data['name']
      end

      attr_reader :name
    end
  end
end
