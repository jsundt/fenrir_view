# frozen_string_literal: true

module FenrirView
  class Component
    attr_reader :variant, :name

    def initialize(variant, name)
      @variant = variant
      @name = name
    end

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

    def stubs_title(index)
      styleguide_stubs[:stubs][index][:name] || "#{ title } #{ index + 1 }"
    end

    def styleguide_stubs
      YAML.load_file(stubs_file) || {}
    rescue Errno::ENOENT
      {}
    end

    def component_stubs
      if styleguide_stubs.is_a?(Hash)
        styleguide_stubs[:stubs] || {}
      elsif styleguide_stubs.is_a?(Array)
        styleguide_stubs
      end
    end

    def component_stubs?
      component_stubs.any?
    end

    def component_layout_sections?
      component_facade.class.const_defined?('VALID_LAYOUT_SECTIONS')
    end

    def component_layout_sections
      component_facade.class.const_get('VALID_LAYOUT_SECTIONS')
    end

    def stubs_file
      FenrirView.pattern_type(variant).join(component_identifier, "#{component_identifier}.yml")
    end

    def stubs?
      styleguide_stubs.any?
    end

    def stubs_extra_info?
      !stubs_extra_info.empty?
    end

    def stubs_extra_info
      if styleguide_stubs.is_a?(Hash) && styleguide_stubs.key?(:meta)
        styleguide_stubs[:meta].symbolize_keys
      else
        {}
      end
    end

    def meta_description
      stubs_extra_info[:description]
    end

    def meta_deprecated
      stubs_extra_info[:deprecated]
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
      if variant == 'system'
        'This is component is only available in the styleguide.'
      elsif health.metrics_available?
        [
          ('Low usage!' if health.low_usage?),
          "Health: #{health.score}%",
          component_usage,
        ].compact.join(' ')
      else
        'Metrics for this component is unavailable 😞'
      end
    end

    def component_usage
      return nil if Rails.env.production?

      [
        '(',
        "Healthy instances: #{health.component_usage_count}",
        "Property hashes: #{health.property_hashes_count}",
        "Deprecated instances: #{health.component_deprecated_count}",
        ')',
      ].join(' ')
    end

    def stubs_correct_format?
      stubs_are_a_hash_with_info? || styleguide_stubs.is_a?(Array)
    end

    def stubs_are_a_hash_with_info?
      styleguide_stubs.is_a?(Hash) && styleguide_stubs.key?(:stubs)
    end

    def filter_types
      [title, variant].join(' ')
    end

    def health
      @health ||= FenrirView::Component::Health.new(variant: variant, component: name)
    end

    private

    def component_facade
      @component_facade ||= FenrirView::Presenter.component_for(variant, component_identifier, {}, validate: false)
    end
  end
end
