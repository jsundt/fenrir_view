module FenrirView
  class Component
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def title
      @name.humanize
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

    def stubs_file
      FenrirView.configuration.components_path.join(name, "#{name}.yml")
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
      stubs_extra_info[:status]
    end

    def meta_used_by?
      stubs_extra_info[:used_by].any?
    end

    def meta_used_by
      stubs_extra_info[:used_by].join(', ')
    end

    def stubs_correct_format?
      stubs_are_a_hash_with_info? || styleguide_stubs.is_a?(Array)
    end

    def stubs_are_a_hash_with_info?
      styleguide_stubs.is_a?(Hash) && styleguide_stubs.key?(:stubs)
    end
  end
end
