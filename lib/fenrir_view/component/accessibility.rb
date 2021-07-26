# frozen_string_literal: true

module FenrirView
  class Component
    class Accessibility
      attr_reader :component, :design_system_policy

      def initialize(component:, design_system_policy: nil)
        @component = component
        @design_system_policy = design_system_policy
      end

      def show_accessibility?
        design_system_policy&.employee?
      end

      def accessibility_available?
        accessibility_report != {}
      end

      def to_accordion
        {
          title: 'Component Accessibility Issues',
          style: [
            theme,
            'spec-component-accessibility-status'
          ].join(' '),
          icon: icon,
          openable: show_accessibility?,
          open: !accessibility_available?
        }
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
          FenrirView::Component::AccessibilityIssue.new(issue: issue)
        end.select(&:display?)
      end

      private

      def accessibility_report
        @accessibility_report ||= begin
          JSON.parse(
            File.read(Rails.root.join("lib/design_system/components/#{component}/accessibility.json")),
            object_class: OpenStruct
          ) || {}
        rescue Errno::ENOENT
          {}
        end
      end

      def overview
        @overview ||= FenrirView::Component::AccessibilityOverview.new
      end

      def overview_scores
        overview.scores_for(component)
      end

      def overview_scores_available?
        !(overview_scores.nil? || accessibility_score.nil? || best_practices_score.nil?)
      end

      def accessibility_score
        overview_scores&.accessibility
      end

      def best_practices_score
        overview_scores&.best_practices
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
end
