require 'porgy/config/target'
require 'porgy/config/style'
require 'porgy/config/font'

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
      @fonts = data['fonts'].map{|font_data| Font.new(font_data)}
    end

    attr_reader :default_target, :targets, :styles, :fonts

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

    def find_font(name)
      found = @fonts.filter{|font| font.name == name}
      raise "Font '#{name}' is not found." if found.empty?
      found[0]
    end
  end
end
