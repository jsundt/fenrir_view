module FenrirView
  class FenrirController < ::ApplicationController

    before_action :load_page

    layout "fenrir_view"

    private

    def load_page
      @page = FenrirView::StyleguideFacade.new()
    end
  end
end
