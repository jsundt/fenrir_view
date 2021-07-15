# frozen_string_literal: true

module FenrirView
  class Component
    class Examples
      attr_reader :variant, :component, :identifier, :facade

      def initialize(variant:, component:, identifier:, facade:)
        @variant = variant
        @component = component
        @identifier = identifier
        @facade = facade
      end

      def component_stubs?
        component_stubs.any?
      end

      def stubs_correct_format?
        stubs_are_a_hash_with_info? || styleguide_stubs.is_a?(Array)
      end

      def stubs_are_a_hash_with_info?
        styleguide_stubs.is_a?(Hash) && styleguide_stubs.key?(:stubs)
      end

      def component_meta_info
        styleguide_stubs.fetch(:meta, {})
      end

      def component_example_devices(stub)
        stub.fetch(:devices, nil) ||
          component_meta_info.fetch(:devices, nil) ||
          ['320x500', '1200x500']
      end

      def component_meta_info?
        !component_meta_info.empty?
      end

      def component_stubs
        component_examples.map.with_index do |stub, index|
          {
            title: stub.fetch(:name, "#{component} #{index + 1}"),
            description: stub.fetch(:description, nil),
            examples: stub_examples(stub),
            devices: component_example_devices(stub),
          }
        end
      end

      def stub_examples(stub)
        if (stub[:yields] || stub[:props]).present?
          [{
            variant: variant,
            name: stub.fetch(:name, "#{component} example"),
            component: component,
            properties: stub.fetch(:props, nil) || stub.fetch(:properties, {}),
            yields: stub.fetch(:yields, []),
          }]
        elsif stub[:examples]
          stub.fetch(:examples).map.with_index(1) do |example, index|
            {
              variant: variant,
              name: example.fetch(:name, "#{component} example #{index}"),
              component: component,
              properties: example.fetch(:properties, {}),
              yields: example.fetch(:yields, []),
            }
          end
        else
          {}
        end
      end

      def stubs_file
        FenrirView.pattern_type(variant).join(identifier, "#{identifier}.yml")
      end

      def stub_properties
        component_examples.flat_map do |stub|
          if (stub[:yields] || stub[:props]).present?
            [{
              properties: stub.fetch(:props, nil) || stub.fetch(:properties, {}),
              yields: stub.fetch(:yields, [])
            }]
          elsif stub[:examples]
            stub.fetch(:examples).map do |example|
              {
                properties: example.fetch(:properties, {}),
                yields: example.fetch(:yields, [])
              }
            end
          else
            {}
          end
        end
      end

      def yields(array)
        @yields ||= array.map do |content|
          OpenStruct.new(
            key?: content[:key].present?,
            key: content.fetch(:key, nil)&.to_sym,
            args: content.fetch(:args, {}),
            content: content.fetch(:content)
          )
        end
      end

      private

      def component_examples
        styleguide_stubs[:stubs] || []
      end

      def styleguide_stubs
        @styleguide_stubs ||= (YAML.load_file(stubs_file) || {}).deep_symbolize_keys
      rescue Errno::ENOENT
        {}
      end
    end
  end
end
