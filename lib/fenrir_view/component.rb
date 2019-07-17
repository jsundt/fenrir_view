# frozen_string_literal: true

module FenrirView
  class Component
    attr_reader :variant, :name, :design_system_policy

    def initialize(variant, name, design_system_policy: nil)
      @variant = variant
      @name = name
      @design_system_policy = design_system_policy
    end

    delegate :stubs_file,
             :component_stubs?,
             :component_stubs,
             :component_stubs_2,
             :stubs_correct_format?,
             :stubs_are_a_hash_with_info?,
             :component_meta_info?,
             to: :examples

    def title
      name.humanize
    end

    def component_identifier
      return "fenrir_view_#{name}" if variant == 'system'

      name
    end

    def default_properties_and_validations
      component_facade.component_property_rule_descriptions
    end

    def meta_description
      examples.component_meta_info[:description]
    end

    def meta_deprecated
      examples.component_meta_info[:deprecated]
    end

    def header_style
      if variant == 'system'
        'u-bg--secondary'
      elsif health.metrics_available?
        if health.usage_healthy? && !health.low_usage?
          'u-bg--silver u-color--charcoal'
        elsif health.usage_shakey?
          'u-bg--warning'
        else
          'u-bg--danger'
        end
      else
        'u-bg--danger'
      end
    end

    def meta_status
      return 'This is component is only available in the styleguide.' if variant == 'system'

      health.to_sentence
    end

    def filter_types
      [title, variant].join(' ')
    end

    def examples
      @examples ||= FenrirView::Component::Examples.new(
        variant: variant,
        component: name,
        identifier: component_identifier,
        facade: component_facade
      )
    end

    def health
      @health ||= FenrirView::Component::Health.new(
        variant: variant,
        component: name,
        design_system_policy: design_system_policy
      )
    end

    def facade_loaded?
      component_facade.present?
    end

    private

    def component_facade
      @component_facade ||= FenrirView::Presenter.component_for(variant, component_identifier, {}, validate: false)
    rescue FenrirView::Presenter::MissingFacadeError
      false
    end
  end
end
