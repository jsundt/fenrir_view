# frozen_string_literal: true

module FenrirView
  class PropertyTypes
    def initialize(component_class:, component_properties:, instance_properties:)
      @component_class = component_class
      @component_properties = component_properties
      @instance_properties = instance_properties
    end

    def validate_properties
      return unless @component_properties.any?

      if !@instance_properties.is_a?(Hash) && @instance_properties != false
        raise "An instance of #{@component_class.name} has properties as #{@instance_properties.class.name}. Should be Hash or false."
      elsif @component_properties.keys != @instance_properties.keys
        unknown_keys = @instance_properties.keys.reject { |key| @component_properties.include?(key) }
        raise "#{@component_class.name} has unkown keys: #{unknown_keys.join(', ')}"
      end

      @instance_properties.each do |property, value|
        property_validations = @component_properties[property]

        if property_validations
          raise "An instance of #{@component_class.name} is missing the required property: #{property}" if value.blank? && property_validations[:required].presence
          raise "An instance of #{@component_class.name} has the wrong type: '#{value.class}' for property: '#{property}' (value: '#{value}'). Should be one of: #{property_validations[:one_of_type]}" unless property_validations[:one_of_type]&.include?(value.class)
          raise "An instance of #{@component_class.name} has the wrong value for property: '#{property}' (value: '#{value}'). Should be one of: #{property_validations[:one_of]}" unless property_validations[:one_of]&.include?(value)
        end
      end
    end
  end
end
