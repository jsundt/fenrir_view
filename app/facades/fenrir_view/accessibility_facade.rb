# frozen_string_literal: true

module FenrirView
  class AccessibilityFacade
    def sorted_scores
      @sorted_scores ||= component_names.map do |component|
        FenrirView::Component::Accessibility.new(component: component)
      end.reject { |c| c.overview_score.nil? }.sort_by(&:overview_score)
    end

    def overall_score
      sorted_scores.sum(&:overview_score) / sorted_scores.length
    end

    def page_reports
      (desktop_report_paths + mobile_report_paths).map do |path|
        path
          .gsub(Rails.root.join('lib/design_system/accessibility/desktop/').to_s, '')
          .gsub(Rails.root.join('lib/design_system/accessibility/mobile/').to_s, '')
          .gsub('.json', '')
      end.uniq.sort_by(&:humanize)
    end

    private

    def component_names
      @component_names ||= Dir.glob(FenrirView.patterns_for('components')).map { |dir| File.basename(dir) }
    end

    def desktop_report_paths
      Dir.glob(
        Pathname.new(
          File.expand_path(Rails.root.join('lib/design_system/accessibility/desktop'), __dir__)
        )
        .join('*')
      )
    end

    def mobile_report_paths
      Dir.glob(
        Pathname.new(
          File.expand_path(Rails.root.join('lib/design_system/accessibility/mobile'), __dir__)
        )
        .join('*')
      )
    end
  end
end
