# frozen_string_literal: true

module FenrirView
  class Component
    class Health
      attr_reader :variant, :component, :design_system_policy

      def initialize(variant:, component:, design_system_policy:)
        @variant = variant
        @component = component
        @design_system_policy = design_system_policy
      end

      def to_sentence
        if metrics_available?
          [
            ('Low usage!' if low_usage?),
            "Health: #{score}%",
            component_usage,
          ].compact.join(' ')
        else
          'Metrics for this component is unavailable 😞'
        end
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

      def can_access_metrics?
        design_system_policy&.employee?
      end

      def component_usage
        return nil unless can_access_metrics?

        usage = [
          "Healthy instances: #{component_usage_count}",
          "Property hashes: #{property_hashes_count}",
          "Deprecated instances: #{component_deprecated_count}",
        ].join(', ')

        "(#{usage})"
      end

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
