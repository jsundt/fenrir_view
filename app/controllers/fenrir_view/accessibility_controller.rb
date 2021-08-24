# frozen_string_literal: true

module FenrirView
  class AccessibilityController < FenrirController
    def index
      @content = FenrirView::AccessibilityFacade.new
    end

    def page
      @content = FenrirView::PageAccessibilityFacade.new(page: params[:page])

      return render_404 unless @content.mobile_report? || @content.desktop_report?
    end
  end
end
