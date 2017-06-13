module FenrirView
  module ComponentHelper
    def render_ui(variant, slug, properties = {})
      component = FenrirView::Presenter.component_for(variant, slug, properties)
      component.render(controller.view_context)
    end

    def render_element(slug, properties = {})
      render_ui('elements', slug, properties)
    end

    def render_component(slug, properties = {})
      render_ui('components', slug, properties)
    end

    def render_module(slug, properties = {})
      render_ui('modules', slug, properties)
    end
  end
end
