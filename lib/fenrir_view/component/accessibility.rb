# frozen_string_literal: true

require 'fenrir_view/accessibility'

module FenrirView
  class Component
    class Accessibility < FenrirView::Accessibility
      attr_reader :component, :design_system_policy

      def initialize(component:, design_system_policy: nil)
        @component = component
        @design_system_policy = design_system_policy
      end

      def to_accordion
        {
          title: 'Component Accessibility Issues',
          style: [
            theme,
            'spec-component-accessibility-status'
          ].join(' '),
          icon: icon,
          open: !accessibility_available?
        }
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
    end
  end
end
