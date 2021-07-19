# frozen_string_literal: true

module FenrirView
  class AccessibilityController < FenrirController
    def index
      @content = FenrirView::AccessibilityFacade.new
    end
  end
end
