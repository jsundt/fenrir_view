require "rails"

module FenrirView
  class Engine < ::Rails::Engine
    isolate_namespace FenrirView

    initializer "fenrir_view.components_path" do |app|
      FenrirView.configure do |c|
        c.components_path ||= app.root.join("app", "components")
      end
    end

    initializer "fenrir_view.load_component_classes",
                before: :set_autoload_paths do |app|
      component_paths = "#{FenrirView.configuration.components_path}/{*}"
      app.config.autoload_paths += Dir[component_paths]
    end

    initializer "fenrir_view.assets" do |app|
      Rails.application.config.assets.paths <<
        FenrirView.configuration.components_path
      Rails.application.config.assets.precompile += %w( fenrir_view/styleguide.css
                                                        fenrir_view/styleguide.js )
    end

    initializer "fenrir_view.append_view_paths" do |app|
      ActiveSupport.on_load :action_controller do
        append_view_path FenrirView.configuration.components_path
      end
    end

    initializer "fenrir_view.add_helpers" do
      ActiveSupport.on_load :action_controller do
        helper FenrirView::ApplicationHelper
        helper FenrirView::ComponentHelper
      end
    end
  end
end
