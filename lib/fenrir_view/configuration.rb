module FenrirView
  class Configuration
    attr_accessor :included_stylesheets
    attr_accessor :styleguide_path
    attr_accessor :system_variants
    attr_reader :system_path
    attr_reader :docs_path

    def initialize
      @included_stylesheets = []
    end

    def system_path=(path)
      @system_path = Pathname.new(path)
    end

    def docs_path=(path)
      @docs_path = Pathname.new(path)
    end
  end
end
