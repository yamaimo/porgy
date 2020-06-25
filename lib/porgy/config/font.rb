require 'pathname'

module Porgy
  class Config
    class Font
      class Mode
        def self.load(font_name, data)
          mode_name = data['name'] or raise "Mode has no name."
          file = data['file']
          index = data['index']

          if file.nil? || file.empty?
            raise "Font file is not specified. (font: #{font_name}, mode: #{mode_name})"
          end

          Mode.new(mode_name, file, index)
        end

        def initialize(name, file, index)
          @name = name
          @file = Pathname.new(file)
          @index = index
        end

        attr_reader :name, :file, :index
      end

      def self.search_path
        @search_path ||= [
          Pathname.pwd,
          Pathname.new(Dir.home)/'Library'/'Fonts',
          Pathname.new('/System/Library/Fonts'),
          Pathname.new('/Library/Fonts'),
        ].delete_if(&:nil?)
      end

      def self.find_path(file)
        found = nil

        if file.absolute?
          if file.exist?
            found = file
          end
        else
          self.search_path.each do |path|
            if (path/file).exist?
              found = path/file
              break
            end
          end
        end

        if not found
          raise "Font file '#{file}' is not found."
        end

        found
      end

      def self.load(data)
        name = data['name'] or raise "Font has no name."
        modes_data = data['modes'] or raise "Font '#{name}' has no mode."
        modes = modes_data.map do |mode_data|
          Mode.load(name, mode_data)
        end

        Font.new(name, modes)
      end

      def initialize(name, modes)
        @name = name
        @modes = modes
        @document = nil
      end

      attr_reader :name, :modes

      def register(document)
        if @document.nil? || (! @document.equal?(document))
          document.font_families[@name] = modes_to_prawn
          @document = document
        end
      end

      private

      def modes_to_prawn
          @modes.map do |mode|
            key = mode.name.to_sym
            path = Font.find_path(mode.file).to_s
            index = mode.index
            setting = index.nil? ? path : {file: path, font: index}
            [key, setting]
          end.to_h
      end
    end
  end
end
