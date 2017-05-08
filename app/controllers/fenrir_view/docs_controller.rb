module FenrirView
  class DocsController < FenrirController

    before_action :doc_pages

    def index
      redirect_to fenrir_docs_path(section: @docs.keys[0], page: @docs.values[0].keys[0])
    end
    
    def show
      redirect_to fenrir_docs_path(section: @docs.keys[0], page: @docs.values[0].keys[0]) unless @docs.keys.include?(params[:section].to_sym)
      redirect_to fenrir_docs_path(section: params[:section], page: @docs[params[:section].to_sym].keys[0]) unless params[:page]

      @doc = "/#{params[:section]}/#{ params[:page] }"
    end

    private

    def doc_pages
      @docs = FenrirView.configuration.docs_pages
    end
  end
end
