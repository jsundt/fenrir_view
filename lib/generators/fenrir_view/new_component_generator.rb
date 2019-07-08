# frozen_string_literal: true

require 'rails/generators/base'

module FenrirView
  module Generators
    class NewComponentGenerator < Rails::Generators::Base
      source_root File.expand_path('../../fenrir_view/templates', __dir__)

      desc 'Generates all files needed for a design system ui component'

      argument :name, required: true,
                      type: :string,
                      desc: 'Component name, e.g: header, widget'

      def create_component_files
        if File.exist?("#{new_component_folder}/_#{component_name}.html.erb")
          raise ArgumentError.new("ERROR: #{component_name} already exists.")
        end

        template '_template.html.erb', "#{new_component_folder}/_#{component_name}.html.erb"
        template 'template_facade.rb', "#{new_component_folder}/#{component_name}_facade.rb"
        template 'template.scss', "#{new_component_folder}/#{component_name}.scss"
        template 'template.js', "#{new_component_folder}/#{component_name}.js"
        template 'template.yml', "#{new_component_folder}/#{component_name}.yml"

        log ''
        log "New component '#{component_name}' setup!"
        log 'Update the asset version in config/initializers/assets.rb to force regeneration of assets.'
        log 'Restart the server.'
        log "Your component will be available at: /design_system/components/#{component_name}"
      end

      private

      def component_name
        name.downcase.underscore
      end

      def css_class_name
        "c-#{component_name.dasherize}"
      end

      def js_class_name
        "js-#{component_name.dasherize}"
      end

      def js_variable_name
        component_name.camelize
      end

      def new_component_folder
        "lib/design_system/components/#{component_name}"
      end
    end
  end
end
