# frozen_string_literal: true

module FenrirView
  module ComponentHelper
    def ui_component(slug, properties = {}, &_block)
      return nil if properties == false

      component = FenrirView::Presenter.component_for('components', slug, properties, validate: true)

      if block_given?
        if component.respond_to?(:layout)
          component.build_layout_from_context(self)

          # This capture is not passed to the generic content_block,
          # as we are making the different parts of the block available
          # to specific parts of the component partial, instead of the
          # regular yield block.
          capture { yield component.layout }
        else
          content_block = capture { yield }
        end
      end

      component.render(controller.view_context) do
        content_block
      end
    end

    def system_component(slug, properties = {}, &_block)
      return nil if properties == false

      component = FenrirView::Presenter.component_for('system', "fenrir_view_#{slug}", properties, validate: true)

      component.render(controller.view_context) do
        capture { yield } if block_given?
      end
    end
  end
end
