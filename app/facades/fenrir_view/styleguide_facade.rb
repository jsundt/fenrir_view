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
        Dir.glob(FenrirView.pattern(variant)).map do |dir|
          components[variant] << FenrirView::Component.new( variant, File.basename(dir) )
        end
      end

      components
    end

    private

    def doc_pages
      @docs = YAML.load_file(docs_index_file)
    end

    def docs_index_file
      FenrirView.configuration.system_path.join('docs', "index.yml")
    end
  end
end
