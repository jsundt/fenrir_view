# frozen_string_literal: true

module FenrirView
  class AccessibilityFacade
    def sorted_scores
      @sorted_scores ||= component_names.map do |component|
        FenrirView::Component::Accessibility.new(component: component)
      end.reject { |c| c.overview_score.nil? }.sort_by(&:overview_score)
    end

    private

    def component_names
      @component_names ||= Dir.glob(FenrirView.patterns_for('components')).map { |dir| File.basename(dir) }
    end
  end
end
