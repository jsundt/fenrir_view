module FenrirView
  module ComponentHelper
    def render_ui(variant, slug, properties = {}, &block)
      component = FenrirView::Presenter.component_for(variant, slug, properties)
      component.render(controller.view_context) do
        capture(&block) if block_given?
      end
    end

    def ui_element(slug, properties = {}, &block)
      render_ui('elements', slug, properties) do
        capture(&block) if block_given?
      end
    end

    def ui_component(slug, properties = {}, &block)
      render_ui('components', slug, properties) do
        capture(&block) if block_given?
      end
    end

    def ui_module(slug, properties = {}, &block)
      render_ui('modules', slug, properties) do
        capture(&block) if block_given?
      end
    end
  end
end
