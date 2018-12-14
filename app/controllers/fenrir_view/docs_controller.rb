# frozen_string_literal: true

module FenrirView
  class DocsController < FenrirController
    def index
      redirect_to fenrir_docs_path(redirect_options)
    end

    # The parameters used to render the show action is validated
    # against your own list of specified documentation pages in docs/index.yml
    def show
      @partial = "/#{ @section.to_s }/#{ @doc.to_s }"
    end

    private

    def redirect_options
      section = valid_pages.keys.first.to_s
      page = valid_pages[section].first.to_s

      {
        section: section,
        page: page
      }
    end

    def valid_pages
      @valid_pages ||= FenrirView::Documentation.new.valid_pages
    end
  end
end
