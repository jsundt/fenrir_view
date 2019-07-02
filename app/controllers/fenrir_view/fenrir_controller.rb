# frozen_string_literal: true

module FenrirView
  class FenrirController < ::ApplicationController
    before_action :load_page

    layout 'fenrir_view'

    private

    def load_page
      @page = FenrirView::StyleguideFacade.new
      @design_system_policy = design_system_policy
    end
  end
end
