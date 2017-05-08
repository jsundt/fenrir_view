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
      component_dirs = FenrirView.configuration.components_path.join("*")

      Dir.glob(component_dirs).map do |component_dir|
        FenrirView::Component.new File.basename(component_dir)
      end
    end
  end
end