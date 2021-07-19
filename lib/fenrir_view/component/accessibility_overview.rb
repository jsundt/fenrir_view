# frozen_string_literal: true

module FenrirView
  class Component
    class AccessibilityOverview
      def scores_for(component)
        report.respond_to?(component) ? report.public_send(component) : nil
      end

      private

      def report
        @report ||= begin
          JSON.parse(
            File.read(Rails.root.join('lib/design_system/accessibility.json')),
            object_class: OpenStruct
          ) || {}
        rescue Errno::ENOENT
          {}
        end
      end
    end
  end
end
