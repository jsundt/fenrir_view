# frozen_string_literal: true

module FenrirView
  class PageAccessibilityFacade
    attr_reader :page

    def initialize(page:)
      @page = page
    end

    def mobile_report?
      mobile_report_source != {}
    end

    def desktop_report?
      desktop_report_source != {}
    end

    def mobile_report
      PageReport.new(accessibility_report: mobile_report_source)
    end

    def desktop_report
      PageReport.new(accessibility_report: desktop_report_source)
    end

    private

    def report(type)
      JSON.parse(
        File.read(Rails.root.join("lib/design_system/accessibility/#{type}/#{page}.json")),
        object_class: OpenStruct
      ) || {}
    rescue Errno::ENOENT
      {}
    end

    def mobile_report_source
      @mobile_report_source ||= report('mobile')
    end

    def desktop_report_source
      @desktop_report_source ||= report('desktop')
    end

    class PageReport < ::FenrirView::Accessibility
      def initialize(accessibility_report:)
        @accessibility_report = accessibility_report
      end
    end
  end
end
