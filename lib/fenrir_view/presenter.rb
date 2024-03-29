# frozen_string_literal: true

module FenrirView
  class Presenter
    class_attribute :_properties, instance_accessor: false
    self._properties = {
      yield: {}
    }

    attr_reader :variant, :slug, :properties

    def initialize(variant:, slug:, properties: {}, validate: true)
      @variant = variant
      @slug = slug
      @properties = default_properties.deep_merge(properties)

      validate_properties if FenrirView.configuration.property_validation && validate
    end

    def render(context, &block)
      context.extend ViewContext
      context.inject_component_context self
      properties[:yield] ||= yield
      context.render partial, partial: partial
    end

    def partial
      "#{slug}/#{slug}"
    end

    def component_property_rule_descriptions
      property_types.component_property_rule_descriptions
    end

    private

    def validate_properties
      property_types.validate_properties
    end

    def property_types
      @property_types ||= ::FenrirView::PropertyTypes.new(
        component_class: self.class,
        component_properties: self.class._properties,
        instance_properties: properties,
      )
    end

    def default_properties
      self.class._properties.inject({}) do |sum, (k, v)|
        sum[k] = v[:default]
        sum
      end
    end

    class MissingFacadeError < ArgumentError; end

    class << self
      def component_for(args)
        klass = "#{args[:slug].to_s.camelize}Facade".safe_constantize
        raise ::FenrirView::Presenter::MissingFacadeError.new("Could not find component: #{args[:variant].to_s}: #{args[:slug].to_s}") unless !!klass

        klass.new(**args)
      end

      def properties(*args)
        opts = args.extract_options!
        properties = args.inject({}) do |sum, name|
          sum[name] = opts
          sum
        end
        define_property_methods(args)
        self._properties = _properties.merge(properties)
      end
      alias_method :property, :properties

      private

      def define_property_methods(names = [])
        names.each do |name|
          next if method_defined?(name)
          define_method name do
            properties[name.to_sym]
          end
        end
      end
    end

    module ViewContext
      attr_reader :component
      delegate :properties, to: :component

      def inject_component_context(component)
        @component = component
      end
    end
  end
end
