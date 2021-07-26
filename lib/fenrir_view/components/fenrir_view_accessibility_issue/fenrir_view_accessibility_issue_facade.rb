# frozen_string_literal: true

class FenrirViewAccessibilityIssueFacade < FenrirView::Presenter
  property :issue

  delegate :debug_data, :description, :details, :failure_as_percentage, :id,
           :score, :score_as_percentage, :score_display_mode, :show_score?,
           :title, to: :issue

  def any_details?
    issue.respond_to?(:details)
  end

  def details_partial
    markup_issues = %w[aria-allowed-attr aria-valid-attr-value button-name
                       color-contrast duplicate-id-aria label link-name]

    partial = if markup_issues.include?(issue.id)
                'markup'
              elsif issue.id == 'errors-in-console'
                'js_errors'
              elsif issue.id == 'valid-source-maps'
                'source_maps'
              else
                'no_partial'
              end

    "fenrir_view_accessibility_issue/partials/#{partial}"
  end
end
