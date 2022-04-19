# frozen_string_literal: true

module FenrirView
  class Accessibility
    attr_reader :accessibility_report

    def accessibility_available?
      accessibility_report != {}
    end

    def report_date
      return unless accessibility_available?

      DateTime.parse(accessibility_report.fetchTime)
    end

    # A combination of the overview scores into one single value.
    def overview_score
      return unless overview_scores_available?

      ((accessibility_score + best_practices_score) / 2) * 100
    end

    def audit
      return unless accessibility_available?

      @audit ||= accessibility_report.audits.to_h.map do |_, issue|
        FenrirView::Component::AccessibilityIssue.new(issue: issue, screenshot: screenshot)
      end
    end

    def audit_for_display
      return if audit.nil? || audit.length.zero?

      @audit_for_display ||= audit.select(&:display?)
    end

    # Returns the base64 encoded screenshot (.data) as well as it's height and
    # width (.height and .width).
    #
    # Note that because of the format of the report is built we have to call a
    # method with hyphens in it, hence the use of public_send.
    def screenshot
      return if accessibility_report == {} ||
                !accessibility_report.audits.respond_to?('full-page-screenshot')

      @screenshot ||= FenrirView::Component::AccessibilityScreenshot.new(
        screenshot: accessibility_report.audits
                                        .public_send('full-page-screenshot')
                                        .details.screenshot
      )
    end

    def accessibility_score
      overview_scores&.accessibility
    end

    def best_practices_score
      overview_scores&.best_practices
    end

    def colour_issues_count
      accessibility_report.audits.public_send('color-contrast')&.details&.items&.length || 0
    end

    def healthy_score?
      overview_score > 90
    end

    def shakey_score?
      overview_score.between?(41, 90)
    end

    def low_score?
      overview_score <= 40
    end

    def theme
      if overview_score.nil?
        'u-bg--gray-05'
      elsif low_score?
        'u-bg--danger-05'
      elsif shakey_score?
        'u-bg--warning-05'
      elsif healthy_score?
        'u-bg--success-05'
      end
    end

    def icon
      if overview_score.nil?
        'unknown_status'
      elsif low_score?
        'low_status'
      elsif shakey_score?
        'shakey_status'
      elsif healthy_score?
        'healthy_status'
      end
    end
  end
end
