# frozen_string_literal: true

module FenrirView
  class Component
    class Health
      attr_reader :variant, :component

      def initialize(variant:, component:)
        @variant = variant
        @component = component
      end

      def score
        return 0 if total_usage.zero?

        ((component_usage_count.to_f / total_usage) * 100).round(0)
      end

      def metrics_available?
        component_metrics.present?
      end

      def low_usage?
        component_usage_count < 10
      end

      def usage_healthy?
        score > 80
      end

      def usage_shakey?
        score > 40
      end

      def total_usage
        component_usage_count + component_deprecated_count
      end

      def component_usage_count
        metrics_available? ? component_metrics[:component_count].to_i : 0
      end

      def property_hashes_count
        metrics_available? ? component_metrics[:property_hashes].to_i : 0
      end

      def component_deprecated_count
        metrics_available? ? component_metrics[:deprecated_instance_count].to_i : 0
      end

      private

      def component_metrics
        metrics_file.dig(:design_system, :metrics, :components, component.to_sym)
      end

      def metrics_file
        return {} if variant == 'system'

        YAML.load_file(Rails.root.join('lib/design_system/metrics.yml')) || {}
      rescue Errno::ENOENT
        {}
      end
    end
  end
end
