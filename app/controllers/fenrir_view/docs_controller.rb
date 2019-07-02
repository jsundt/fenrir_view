# frozen_string_literal: true

module FenrirView
  class DocsController < FenrirController
    def index
      redirect_to fenrir_docs_path(redirect_options)
    end

    # The parameters used to render the show action is validated
    # against your own list of specified documentation pages in docs/index.yml
    def show
      return render template: 'fenrir_view/docs/show_locked' unless can_show_page?

      render template: "#{params[:section]}/#{params[:page]}"
    rescue ActionView::MissingTemplate
      render template: 'fenrir_view/docs/missing'
    end

    private

    def can_show_page?
      whitelisted_page? || @design_system_policy&.employee?
    end

    def redirect_options
      section = valid_pages.keys.first.to_s
      page = valid_pages[section].first.to_s

      {
        section: section,
        page: page
      }
    end

    def whitelisted_page?
      documentation.unlocked_sections.include?("#{params[:section]}/#{params[:page]}")
    end

    def valid_pages
      @valid_pages ||= documentation.valid_pages
    end

    def documentation
      @documentation ||= FenrirView::Documentation.new
    end
  end
end
