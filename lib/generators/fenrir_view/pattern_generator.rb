require "rails/generators/base"

module FenrirView
  module Generators
    class PatternGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../fenrir_view/templates', __FILE__)

      desc "Generates all files needed for a design system pattern"

      argument :type, required: true,
                      type: :string,
                      desc: "Pattern type: elements || components || modules"
      argument :name, required: true,
                      type: :string,
                      desc: "Pattern name, e.g: header, widget"

      def create_pattern_files
        if File.exist?("#{ new_component_folder }/_#{ pattern_name }.html.erb")
          raise ArgumentError.new("ERROR: #{ pattern_name } already exists.")
        end

        template "_template.html.erb", "#{ new_component_folder }/_#{ pattern_name }.html.erb"
        template "template_facade.rb", "#{ new_component_folder }/#{ pattern_name }_facade.rb"
        template "template.scss", "#{ new_component_folder }/#{ pattern_name }.scss"
        template "template.js", "#{ new_component_folder }/#{ pattern_name }.js"
        template "template.yml", "#{ new_component_folder }/#{ pattern_name }.yml"

        log ""
        log "New pattern '#{ pattern_name }' setup!"
        log "Update the asset version in config/initializers/assets.rb to force regeneration of assets."
        log "Restart the server."
        log "Your pattern will be available at: /design_system/styleguide/#{ pattern_type_name }/#{ pattern_name }"
      end


      private

      def pattern_type_name
        case type
        when 'element', 'elements'
          'elements'
        when 'component', 'components'
          'components'
        when 'module', 'modules'
          'modules'
        else
          raise ArgumentError.new("ERROR: Pattern type was: #{ type }, should be: 'element', 'component', or 'module'!")
        end
      end

      def pattern_type_prefix
        pattern_type_name[0]
      end

      def pattern_name
        name.downcase.underscore
      end

      def css_class_name
        "#{ pattern_type_prefix }-#{ pattern_name.dasherize }"
      end

      def new_component_folder
        "lib/design_system/#{ pattern_type_name }/#{ pattern_name }"
      end
    end
  end
end
