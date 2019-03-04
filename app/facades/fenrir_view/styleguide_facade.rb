# frozen_string_literal: true

module FenrirView
  class StyleguideFacade
    def docs
      FenrirView::Documentation.new.sections
    end

    def components
      components = []

      sorted_components_for('components').map do |dir|
        components.push(FenrirView::Component.new('components', File.basename(dir)))
      end

      components
    end

    def system_components
      items = []

      sorted_components_for('system').map do |dir|
        item_name = File.basename(dir).delete_prefix('fenrir_view_')
        items.push(FenrirView::Component.new('system', item_name))
      end

      items
    end

    def top_line_metrics
      return [] if metrics.nil?
      [
        "System saturation: #{metrics.dig(:totals, :saturation)}%",
        "Total component instances: #{metrics.dig(:totals, :components)}",
        "Total deprecated instances: #{metrics.dig(:totals, :deprecated)}",
      ]
    end

    private

    def sorted_components_for(pattern_variant)
      Dir.glob(FenrirView.patterns_for(pattern_variant)).sort_by! { |pattern| File.basename(pattern) }
    end

    def metrics
      @metrics ||= YAML.load_file(Rails.root.join('lib', 'design_system', 'metrics.yml')).dig(:design_system, :metrics) || {}
    end
  end
end
