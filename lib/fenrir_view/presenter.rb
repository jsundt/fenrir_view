module FenrirView
  class Presenter
    class_attribute :_properties, instance_accessor: false
    self._properties = {}

    attr_reader :variant, :slug, :properties

    def initialize(variant, slug, properties = {})
      @variant = variant
      @slug = slug
      @properties = default_properties.deep_merge(properties)
      validate_properties if FenrirView.configuration.property_validation
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

    private

    def validate_properties
      validations_for_component = self.class._properties
      return unless validations_for_component.any?

      if !properties.is_a?(Hash) && properties != false
        raise "An instance of #{slug} has properties as #{properties.class.name}. Should be Hash or false."
      elsif validations_for_component.keys != properties.keys
        unknown_keys = properties.keys.reject { |key| validations_for_component.include?(key) }
        raise "#{self.class.name} has unkown keys: #{unknown_keys.join(', ')}"
      end

      properties.each do |k, v|
        property_validations = validations_for_component[k]

        if property_validations
          raise "An instance of #{slug} is missing the required property: #{k}" if v.blank? && property_validations[:required].presence
          raise "An instance of #{slug} has the wrong type: '#{v.class}' for property: '#{k}' (value: '#{v}'). Should be one of: #{property_validations[:one_of_type]}" unless property_validations[:one_of_type]&.include?(v.class)
          raise "An instance of #{slug} has the wrong value for property: '#{k}' (value: '#{v}'). Should be one of: #{property_validations[:one_of]}" unless property_validations[:one_of]&.include?(v)
        end
      end
    end

    def default_properties
      self.class._properties.inject({}) do |sum, (k, v)|
        sum[k] = v[:default]
        sum
      end
    end

    class << self
      def component_for(*args)
        klass = "#{args.second.to_s.camelize}Facade".safe_constantize
        klass ||= self
        klass.new(*args)
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
      attr_reader :_component
      delegate :properties, to: :_component

      def inject_component_context(component)
        @_component = component
        protected_methods = FenrirView::Presenter.public_methods(false)
        methods = component.public_methods(false) - protected_methods
        methods.each do |meth|
          next if self.class.method_defined?(meth)
          self.class.delegate meth, to: :_component
        end
      end
    end
  end
end
