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
             :stubs_correct_format?,
             :stubs_are_a_hash_with_info?,
             :component_meta_info?,
             :stub_properties,
             :yields,
             to: :examples

    delegate :can_access_metrics?, to: :health

    def title
      name.humanize
    end

    def component_identifier
      return "fenrir_view_#{name}" if system_component?

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
      if system_component?
        'u-bg--secondary'
      elsif !component_stubs?
        'u-bg--warning'
      else
        'u-bg--white'
      end
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
        examples: examples,
        design_system_policy: design_system_policy
      )
    end

    def facade_loaded?
      component_facade.present?
    end

    def system_component?
      variant == 'system'
    end

    private

    def component_facade
      @component_facade ||= FenrirView::Presenter.component_for(variant, component_identifier, {}, validate: false)
    rescue FenrirView::Presenter::MissingFacadeError
      false
    end
  end
end
