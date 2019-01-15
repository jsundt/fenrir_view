module FenrirView
  module ComponentHelper
    def render_ui(variant, slug, properties = {}, &block)
      return nil if properties == false

      component = FenrirView::Presenter.component_for(variant, slug, properties, validate: true)
      component.render(controller.view_context) do
        capture(&block) if block_given?
      end
    end

    def ui_component(slug, properties = {}, &block)
      render_ui('components', slug, properties) do
        capture(&block) if block_given?
      end
    end

    def system_component(slug, properties = {}, &block)
      render_ui('system', "fenrir_view_#{slug}", properties) do
        capture(&block) if block_given?
      end
    end
  end
end
