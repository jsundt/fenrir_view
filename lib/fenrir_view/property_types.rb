# frozen_string_literal: true

module FenrirView
  class PropertyTypes
    def initialize(component_class:, component_properties:, instance_properties:)
      @component_class = component_class
      @component_properties = component_properties
      @instance_properties = instance_properties
    end

    VALID_KEYS = [:required, :one_of_type, :one_of, :array_of, :hash_of, :deprecated, :default, :note]
    VALIDATION_KEYS = [:required, :one_of_type, :one_of, :array_of, :hash_of, :deprecated]

    def validate_properties
      return if @instance_properties == false # Rendering of this instance has been blocked by a guard clause
      raise invalid_component_properties unless @instance_properties.is_a?(Hash)
      raise unknown_keys if instance_has_unknown_keys?

      @instance_properties.each do |property, value|
        validate_property(property, value, @component_properties[property])
      end
    end

    def validate_property(property, value, property_validations)
      raise deprecated_property(property) if !value.nil? && !!property_validations[:deprecated]
      raise unknown_validation(property_validations.except(*VALID_KEYS)) if property_validations.except(*VALID_KEYS).any?

      property_validations.slice(*VALIDATION_KEYS).each do |validation_type, validation_rule|
        case validation_type
        when :required
          raise wrong_validation_format(validation_type, validation_rule, 'Boolean') unless !!validation_rule == validation_rule
          raise required_property_missing(property, value) if value.blank? && !!validation_rule
        when :one_of_type
          raise invalid_property_type(property, value, validation_rule) if value.present? && !validation_rule.include?(value.class)
        when :one_of
          raise invalid_property_value(property, value, validation_rule) if value.present? && !validation_rule.include?(value)
        when :array_of
          raise invalid_property_type(property, value, validation_rule) if value.present? && !value.is_a?(Array)

          value.each_with_index do |v, i|
            validate_property("#{property}[#{i}]", v, property_validations[:array_of])
          end
        when :hash_of
          raise invalid_property_type(property, value, validation_rule) if value.present? && !value.is_a?(Hash)

          # Loop over the validations for the keys in this hash
          # and check that the 'value' conforms to those rules
          property_validations[:hash_of].each do |k, key_validations|
            validate_property("#{property}[#{k}]", value[k], key_validations)
          end
        end
      end
    end

    def component_property_rule_descriptions
      prop_map = {}

      @component_properties.map do |name, data|
        prop_map[name] = {
          info: [
            (data[:default] ? ": #{default_value_with_visible_type(data[:default])}" : ''),
            ('⚠️ Deprecated' if data[:deprecated]),
            ('Required' if data[:required]),
            ("As #{data[:one_of_type].join(' or ')}" if data[:one_of_type]),
          ].compact.join('. '),
          note: data[:note],
          validations: {
            # one_of_type: data[:one_of_type]&.join(', '),
            one_of: data[:one_of],
            array_of: data[:array_of],
            hash_of: data[:hash_of],
          }.compact,
        }
      end

      prop_map
    end

    private

    def default_value_with_visible_type(property)
      if property.is_a?(String)
        "'#{property.blank? ? ' ' : property}'"
      elsif property.is_a?(Symbol)
        ":#{property}"
      else
        property
      end
    end

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

    def wrong_validation_format(rule, current_value, valid_type)
      ArgumentError.new("An instance of #{@component_class.name} has a #{rule} validation with a value of '#{current_value}', but it should be of type: #{valid_type}")
    end

    def deprecated_property(property)
      ArgumentError.new("An instance of #{@component_class.name} is using the deprecated property #{property}")
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
      ArgumentError.new("#{@component_class.name} has unkown property validations: #{unkown_validations.keys.join(', ')}. Should be one of: #{VALID_KEYS.join(', ')}")
    end
  end
end
