require 'porgy/config/target'
require 'porgy/config/style'
require 'porgy/config/font'

require 'yaml'

module Porgy
  class Config
    def self.porgy_yaml_template
      <<~END_OF_PORGY_YAML
        version: 0.1.0

        default_target: all

        targets:
            - name: all
              documents: \#{documents}
              scripts: \#{scripts}
              output: book.pdf
              style: default

        styles:
            - name: default
              paper_size: a4
              paper_margin: 0.5.in
              font:
                  name: ipaex
                  mode: normal
                  size: 10.pt
              baseline_skip: 12.pt

        fonts:
            - name: ipaex
              modes:
                  - name: normal
                    file: ipaexm.ttf
                  - name: bold
                    file: ipaexg.ttf
      END_OF_PORGY_YAML
    end

    def self.load(file)
      data = YAML.load_file(file)

      default_target = data['default_target']
      targets = data['targets'].map{|target_data| Target.load(target_data)}
      styles = data['styles'].map{|style_data| Style.load(style_data)}
      fonts = data['fonts'].map{|font_data| Font.load(font_data)}

      Config.new(default_target, targets, styles, fonts)
    end

    def initialize(default_target, targets, styles, fonts)
      @default_target = default_target
      @targets = targets
      @styles = styles
      @fonts = fonts
    end

    attr_reader :default_target, :targets, :styles, :fonts

    def target_names
      @targets.map(&:name)
    end

    def find_target(name)
      found = @targets.filter{|target| target.name == name}
      raise "Target '#{name}' is not found." if found.empty?
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
