# frozen_string_literal: true

module FenrirView
  class Component
    class AccessibilityIssue
      attr_reader :issue, :screenshot

      delegate :details, :id, :score, :scoreDisplayMode, :title, to: :issue
      delegate :debugData, to: :details
      delegate :extension, to: :screenshot, prefix: true

      alias debug_data debugData
      alias score_display_mode scoreDisplayMode

      EXCLUDED_IDS = %w[
        service-worker first-contentful-paint largest-contentful-paint
        first-meaningful-paint speed-index total-blocking-time max-potential-fid
        interactive installable-manifest apple-touch-icon splash-screen
        themed-omnibox maskable-icon uses-rel-preconnect meta-description
        is-crawlable
      ].freeze
      EXCLUDED_DISPLAY_MODES = %w[informative manual notApplicable].freeze

      def initialize(issue:, screenshot: nil)
        @issue = issue
        @screenshot = screenshot
      end

      def display?
        return false if EXCLUDED_IDS.include?(id)
        return false if EXCLUDED_DISPLAY_MODES.include?(score_display_mode)
        return false if score_display_mode == 'binary' && ActiveModel::Type::Boolean.new.serialize(score)
        return false if score_display_mode == 'numeric' && score >= 1

        true
      end

      def show_score?
        score_display_mode == 'numeric'
      end

      def score_as_percentage
        return unless score_display_mode == 'numeric'

        score * 100
      end

      def failure_as_percentage
        return unless score_display_mode == 'numeric'

        100 - score_as_percentage
      end

      def description
        # The audit issue's description often has read more links marked up
        # with Markdown. We'll use a bit of RegEx to turn them into HTML.
        CGI.escapeHTML(issue.description).gsub(%r{
          \[( [^\]]+)\]
          \(([^)]+)\)
        }x, '<a href="\2" target="_blank" rel="noopener noreferrer">\1</a>').html_safe
      end

      def screenshot?(detail)
        !@screenshot.nil? && !detail.node.boundingRect.nil?
      end

      def cropped_screenshot(detail)
        return unless screenshot?(detail)

        @screenshot.cropped(
          **detail.node.boundingRect.to_h.slice(:width, :height, :top, :left)
        )
      end
    end
  end
end
