module FenrirView
  module ComponentHelper
    def render_ui(slug, variant, properties = {})
      component = FenrirView::Presenter.component_for(slug, variant, properties)
      component.render(controller.view_context)
    end

    def render_element(slug, properties = {})
      render_ui(slug, 'elements', properties)
    end

    def render_component(slug, properties = {})
      render_ui(slug, 'components', properties)
    end

    def render_module(slug, properties = {})
      render_ui(slug, 'modules', properties)
    end
  end
end
