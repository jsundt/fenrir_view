module FenrirView
  class DocsController < FenrirController

    before_action :doc_pages
    before_action :fallback_section

    def index
      redirect_to fenrir_docs_path(section: @section, page: @doc)
    end

    def show
      @doc = "/#{ @section.to_s }/#{ @doc.to_s }"
    end

    private

    def fallback_section
      @section = doc_sections.include?(params[:section]&.to_sym) ? params[:section] : doc_sections.first
      @doc = params[:page] ? params[:page] : @docs[@docs.keys.first][@section].first[0]
      
    end

    def doc_sections
      @sections = []

      @docs.keys.each do |key|
        @sections += @docs[key].keys
      end

      @sections
    end

    def doc_pages
      yml_docs = YAML.load_file(docs_index_file)
      @docs = JSON.parse(JSON[yml_docs], symbolize_names: true)
    end

    def docs_index_file
      FenrirView.configuration.system_path.join('docs', "index.yml")
    end
  end
end
