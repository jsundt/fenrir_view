module FenrirView
  module ComponentHelper
    def render_component(slug, properties = {})
      component = FenrirView::Presenter.component_for(slug, properties)
      component.render(controller.view_context)
    end
  end
end
