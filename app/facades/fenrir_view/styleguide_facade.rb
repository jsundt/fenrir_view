module FenrirView
  class StyleguideFacade
    def initialize()
      @docs = doc_pages
    end

    def docs
      @docs.map do |key, value|
        FenrirView::Docs.new(key, value)
      end
    end

    def components
      components = {}

      FenrirView.configuration.system_variants.each do |variant|
        components[variant] = []

        sorted_components_for(variant).map do |dir|
          components[variant] << FenrirView::Component.new( variant, File.basename(dir) )
        end
      end

      components
    end

    private

    def sorted_components_for(pattern_variant)
      Dir.glob(FenrirView.patterns_for(pattern_variant)).sort_by!{ |pattern| File.basename(pattern) }
    end

    def doc_pages
      @docs = YAML.load_file(docs_index_file)
    end

    def docs_index_file
      FenrirView.configuration.docs_path.join("index.yml")
    end
  end
end
