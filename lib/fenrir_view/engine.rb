# frozen_string_literal: true

require 'rails'

module FenrirView
  class Engine < ::Rails::Engine
    isolate_namespace FenrirView

    initializer 'fenrir_view.system_path' do |app|
      FenrirView.configure do |c|
        c.system_path ||= app.root.join('lib', 'design_system')
      end
    end

    initializer 'fenrir_view.system_variants' do |app|
      FenrirView.configure do |c|
        c.system_variants ||= ['elements', 'components', 'modules', 'views']
      end
    end

    initializer 'fenrir_view.docs_path' do |app|
      FenrirView.configure do |c|
        c.docs_path ||= FenrirView.configuration.system_path.join('docs')
      end
    end

    initializer 'fenrir_view.property_validation' do |app|
      FenrirView.configure do |c|
        c.property_validation ||= !Rails.env.production?
      end
    end

    initializer 'fenrir_view.load_classes', before: :set_autoload_paths do |app|
      FenrirView.configuration.system_variants.each do |variant|
        system_paths = "#{FenrirView.patterns_for(variant)}"
        app.config.eager_load_paths += Dir[system_paths]
      end

      docs_path = "#{FenrirView.configuration.docs_path}/{*}"
      app.config.eager_load_paths += Dir[docs_path]

      system_components_path = FenrirView.patterns_for('system').to_s
      app.config.eager_load_paths += Dir[system_components_path]
    end

    initializer 'fenrir_view.assets' do |app|
      FenrirView.configuration.system_variants.each do |variant|
        Rails.application.config.assets.paths << FenrirView.pattern_type(variant).to_s
      end

      Rails.application.config.assets.paths << FenrirView.pattern_type('system').to_s

      Rails.application.config.assets.precompile += %w[ fenrir_view/styleguide.css
                                                        fenrir_view/styleguide.js ]
    end

    initializer 'fenrir_view.append_view_paths' do |app|
      ActiveSupport.on_load :action_controller do
        FenrirView.configuration.system_variants.each do |variant|
          append_view_path FenrirView.pattern_type(variant).to_s
        end
        append_view_path FenrirView.pattern_type('system').to_s

        append_view_path FenrirView.configuration.docs_path
      end
    end

    initializer 'fenrir_view.add_helpers' do
      ActiveSupport.on_load :action_controller do
        ::ActionController::Base.helper FenrirView::ComponentHelper
      end
    end
  end
end
