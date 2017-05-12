module FenrirView
  class StyleguideFacade
    def initialize()
    end

    def docs
      FenrirView.configuration.docs_pages.map do |key, value|
        FenrirView::Docs.new(key, value)
      end
    end

    def components
      components = {}

      FenrirView.configuration.system_variants.each do |variant|
        dirs = FenrirView.configuration.system_path.join(variant, '*')

        components[variant] = []

        Dir.glob(dirs).map do |dir|
          components[variant] << FenrirView::Component.new( variant, File.basename(dir) )
        end
      end

      components
    end
  end
end
