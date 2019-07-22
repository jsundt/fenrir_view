class FenrirViewIconFacade < FenrirView::Presenter
  include FenrirViewIcons

  property :icon, required: true, one_of_type: [String]
  property :style

  delegate :content_tag, :concat, to: :@context

  # Override the inherited render method to not read partials from the file system.
  def render(context, &_block)
    @context = context

    content_tag(:svg, svg_icon_options) do
      concat(icon)
    end
  end

  def svg_icon_options
    {
      viewBox: icon_view_box,
      class: item_classes,
    }
  end

  def item_classes
    item_classes = ['fenrir-view-icon', 'js-fenrir-view-icon']
    item_classes.push(style) if style?

    item_classes.join(' ')
  end

  def style?
    !!style
  end

  def icon
    return fallback_icon unless known_icon?

    public_send(icon_method_name)
  end

  def icon_view_box
    case icon_method_name.to_sym
    when :healthy_status_icon, :shakey_status_icon, :low_status_icon, :unknown_status_icon, :deprecated_status_icon
      '0 0 60 60'
    else
      '0 0 50 50'
    end
  end

  private

  def known_icon?
    respond_to?(icon_method_name)
  end

  def icon_method_name
    "#{properties[:icon]}_icon"
  end
end
