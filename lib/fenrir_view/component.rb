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

    def meta_status
      case meta_status_code
      when 'work in progress'
        {
          bg: "u-bg--warning",
          code: meta_status_code,
        }
      when 'in review'
        {
          bg: "u-bg--primary",
          code: meta_status_code,
        }
      when 'in use'
        {
          bg: "u-bg--silver",
          code: meta_status_code,
        }
      else
        {
          bg: "u-bg--danger",
          code: meta_status_code,
        }
      end
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

    private

    def component_facade
      @component_facade ||= FenrirView::Presenter.component_for(variant, component_identifier, {}, validate: false)
    end

    def meta_status_code
      code = stubs_extra_info[:status]&.downcase

      if status_codes.include?(code)
        code
      elsif code.present?
        "Unknown status: #{ code }"
      else
        'missing'
      end
    end

    def status_codes
      ['deprecated', 'work in progress', 'in review', 'in use']
    end
  end
end
