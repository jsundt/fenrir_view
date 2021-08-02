# frozen_string_literal: true

module FenrirView
  class Page
    class Accessibility < FenrirView::Accessibility
      def initialize(report_path:)
        @report_path = report_path
      end

      private

      def accessibility_report
        @accessibility_report ||= begin
          JSON.parse(
            File.read(@report_path),
            object_class: OpenStruct
          ) || {}
        rescue Errno::ENOENT
          {}
        end
      end
    end
  end
end
