# frozen_string_literal: true

class FenrirViewAccessibilityIssueFacade < FenrirView::Presenter
  property :issue

  delegate :description, :failure_as_percentage, :id, :score,
           :score_as_percentage, :score_display_mode, :show_score?, :title,
           to: :issue
end
