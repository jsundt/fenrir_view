# frozen_string_literal: true

module FenrirView
  class Component
    class Health
      attr_reader :variant, :component, :design_system_policy, :examples

      def initialize(variant:, component:, examples:, design_system_policy:)
        @variant = variant
        @component = component
        @examples = examples
        @design_system_policy = design_system_policy
      end

      def to_accordion
        {
          title: [
            status,
            usage_status,
          ].compact.join('. '),
          style: [
            theme,
            'spec-component-health-status',
          ].join(' '),
          icon: icon,
          openable: can_access_metrics?,
        }
      end

      def to_sentence
        if metrics_available?
          [
            usage_status,
            "Health: #{score}%",
            component_usage,
          ].compact.join('. ')
        end
      end

      def deprecated_grep_statement
        text = if !component_deprecated_count.zero?
                 "Find deprecated instances by searching for:"
               else
                 "Found no deprecated instances by searching for:"
               end

        [
          text,
          examples.component_meta_info.fetch(:deprecated, 'No regex rules defined'),
        ].join(' ')
      end

      def icon
        if !metrics_available?
          'unknown_status'
        elsif deprecated?
          'deprecated_status'
        elsif low_score?
          'low_status'
        elsif healthy_score?
          'healthy_status'
        elsif shakey_score?
          'shakey_status'
        end
      end

      def status
        if !metrics_available?
          'Health unavailable'
        elsif deprecated?
          'Deprecated component'
        elsif low_score?
          'Low'
        elsif healthy_score?
          'Healthy'
        elsif shakey_score?
          'Shakey'
        end
      end

      def theme
        if !metrics_available?
          'u-bg--gray-05'
        elsif deprecated? || low_score?
          'u-bg--danger-05'
        elsif healthy_score?
          'u-bg--success-05'
        elsif shakey_score?
          'u-bg--warning-05'
        end
      end

      def usage_status
        return unless can_access_metrics? && metrics_available?

        if component_usage_count.zero?
          'Not in use'
        elsif component_usage_count < 10
          'Low usage'
        elsif component_usage_count > 100
          'High usage'
        else
          'In use'
        end
      end

      def can_access_metrics?
        design_system_policy&.employee?
      end

      private

      def score
        return 0 if total_usage.zero?

        ((component_usage_count.to_f / total_usage) * 100).round(0)
      end

      def healthy_score?
        score > 80
      end

      def shakey_score?
        score.between?(41, 80)
      end

      def low_score?
        score <= 40
      end

      def deprecated?
        false
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

      def component_usage
        return nil unless can_access_metrics?

        usage = [
          "Healthy instances: #{component_usage_count}",
          "Property hashes: #{property_hashes_count}",
          "Deprecated instances: #{component_deprecated_count}",
        ].join(', ')

        "(#{usage})"
      end

      def metrics_available?
        component_metrics.present?
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
