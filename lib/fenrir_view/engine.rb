require "rails"

module FenrirView
  class Engine < ::Rails::Engine
    isolate_namespace FenrirView

    initializer "fenrir_view.components_path" do |app|
      FenrirView.configure do |c|
        c.components_path ||= app.root.join("app", "design_system", "components")
      end
    end

    initializer "fenrir_view.docs_path" do |app|
      FenrirView.configure do |c|
        c.docs_path ||= app.root.join("app", "design_system", "docs")
      end
    end

    initializer "fenrir_view.docs_pages" do |app|
      FenrirView.configure do |c|
        c.docs_pages ||= {
          'overview': {
            'welcome': 'Overview',
            'principles': 'Design Principles',
          },
          'guidelines': {
            'welcome': 'Design Language',
            'colors': 'Color Palette',
            'typography': 'Typography Hierarchy',
          },
          'blocks': {
            'welcome': 'Building blocks',
            'wrappers': 'Wrappers',
            'objects': 'Objects',
            'grid': 'Grids',
            'utilities': 'Utilities',
          },
        }
      end
    end

    initializer "fenrir_view.load_component_classes", before: :set_autoload_paths do |app|
      component_paths = "#{FenrirView.configuration.components_path}/{*}"
      app.config.autoload_paths += Dir[component_paths]
    end

    initializer "fenrir_view.docs_classes", before: :set_autoload_paths do |app|
      docs_path = "#{FenrirView.configuration.docs_path}/{*}"
      app.config.autoload_paths += Dir[docs_path]
    end

    initializer "fenrir_view.assets" do |app|
      Rails.application.config.assets.paths << FenrirView.configuration.components_path
      # Rails.application.config.assets.precompile += [ /(^inline[^_\/]|\/[^_])[^\/]*.(css)$/ ] # precompile any CSS or JS file that doesn't start with _
      Rails.application.config.assets.precompile += %w( fenrir_view/styleguide.css
                                                        fenrir_view/styleguide.js )
    end

    initializer "fenrir_view.append_view_paths" do |app|
      ActiveSupport.on_load :action_controller do
        append_view_path FenrirView.configuration.components_path
        append_view_path FenrirView.configuration.docs_path
      end
    end

    initializer "fenrir_view.add_helpers" do
      ActiveSupport.on_load :action_controller do
        helper FenrirView::ApplicationHelper
        helper FenrirView::ComponentHelper
        helper FenrirView::AssetsHelper
      end
    end
  end
end
