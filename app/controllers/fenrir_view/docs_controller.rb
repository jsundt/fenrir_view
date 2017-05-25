module FenrirView
  class DocsController < FenrirController

    before_action :doc_pages
    before_action :fallback_section

    def index
      redirect_to fenrir_docs_path(section: @section, page: @doc)
    end

    def show
      unless @docs.keys.include?(params[:section]) || params[:page].nil?
        redirect_to fenrir_docs_path(section: @section, page: @doc)
      end

      @doc = "/#{ @section }/#{ @doc }"
    end

    private

    def fallback_section
      @section = @docs.keys.include?(params[:section]) ? params[:section] : @docs.first[0]
      @doc = params[:page] ? params[:page] : @docs[@section].first[0]
    end

    def doc_pages
      @docs = YAML.load_file(docs_index_file)
    end

    def docs_index_file
      FenrirView.configuration.system_path.join('docs', "index.yml")
    end
  end
end
