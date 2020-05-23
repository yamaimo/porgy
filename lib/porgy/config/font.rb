require 'pathname'

module Porgy
  class Config
    class Font
      class Style
        def initialize(name, style_data)
          @name = name
          case style_data
          when String
            @file = style_data
            @index = nil
          when Hash
            @file = style_data['file']
            @index = style_data['index']
          end
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

      def self.find_path(filename)
        found = nil
        path = Pathname.new(filename)
        if path.absolute?
          if path.exist?
            found = path
          end
        else
          self.search_path.each do |dir|
            if (dir/path).exist?
              found = dir/path
              break
            end
          end
        end
        raise "Font file '#{filename}' is not found." unless found
        found
      end

      def initialize(data)
        @name = data['name'] or raise "Font has no name."
        styles = data['styles'] or raise "Font '#{@name}' has no styles."
        @styles = styles.map{|name, style_data| Style.new(name, style_data)}
        @registered = false
      end

      attr_reader :name, :styles

      def register(document)
        unless @registered
          style_hash = @styles.map do |style|
            key = style.name.to_s
            path = Font.find_path(Pathname.new(style.file))
            index = style.index
            setting = index.nil? ? path : {file: path, font: index}
            [key, setting]
          end.to_h
          document.font_families[@name] = style_hash
          @registered = true
        end
      end
    end
  end
end
