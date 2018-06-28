# frozen_string_literal: true

module FenrirView
  class PropertyTypes
    def initialize(component_class:, component_properties:, instance_properties:)
      @component_class = component_class
      @component_properties = component_properties
      @instance_properties = instance_properties
    end

    ALL_TYPES = [:default, :required, :one_of_type, :one_of, :note]
    VALIDATION_TYPES = [:required, :one_of_type, :one_of]

    def validate_properties
      return if @instance_properties == false # Rendering of this instance has been blocked by a guard clause
      raise invalid_component_properties unless @instance_properties.is_a?(Hash)
      raise unknown_keys if instance_has_unknown_keys?

      @instance_properties.each do |property, value|
        properties = @component_properties[property]
        property_validations = properties.slice(*VALIDATION_TYPES)

        property_validations.each do |validation_type, validation_rule|
          case validation_type
          when :required
            raise required_property_missing(property, value) if value.blank?
          when :one_of_type
            raise invalid_property_type(property, value, validation_rule) if value.present? && !validation_rule.include?(value.class)
          when :one_of
            raise invalid_property_value(property, value, validation_rule) if value.present? && !validation_rule.include?(value)
          end
        end

        raise unknown_validation(properties.except(*ALL_TYPES)) if properties.except(*ALL_TYPES).any?
      end
    end

    def component_property_rule_descriptions
      prop_map = {}

      @component_properties.map do |name, data|
        prop_map[name] = {
          default: data[:default] || 'nil',
          required: data[:required] ? 'Required' : 'Optional',
          one_of_type: data[:one_of_type]&.join(', ') || 'Any type',
          one_of: data[:one_of]&.join(', ') || 'Any value',
          note: data[:note] || '',
        }
      end

      prop_map
    end

    private

    def invalid_component_properties
      ArgumentError.new("An instance of #{@component_class.name} has properties as #{@instance_properties.class.name}. Should be Hash or false.")
    end

    def instance_has_unknown_keys?
      @component_properties.keys != @instance_properties.keys
    end

    def unknown_keys
      unknown_keys = @instance_properties.keys.reject { |key| @component_properties.include?(key) }
      ArgumentError.new("#{@component_class.name} has unkown keys: #{unknown_keys.join(', ')}. Should be one of: #{@component_properties.keys.join(', ')}")
    end

    def required_property_missing(property, value)
      ArgumentError.new("An instance of #{@component_class.name} is missing the required property: #{property}")
    end

    def invalid_property_type(property, value, validation_rule)
      ArgumentError.new("An instance of #{@component_class.name} has the wrong type: '#{value.class}' for property: '#{property}'. The value is: '#{value}', Should be one of: #{validation_rule.join(', ')}")
    end

    def invalid_property_value(property, value, validation_rule)
      ArgumentError.new("An instance of #{@component_class.name} has the wrong value for property: '#{property}' (value: '#{value}'). Should be one of: #{validation_rule.join(', ')}")
    end

    def unknown_validation(unkown_validations)
      ArgumentError.new("#{@component_class.name} has unkown property validations: #{unkown_validations.keys.join(', ')}. Should be one of: #{ALL_TYPES.join(', ')}")
    end
  end
end
