class ButtonFacade < FenrirView::Presenter
  properties :title, :link, :style, :remote, :trigger

  def title
    properties[:title].titleize
  end

  def html_options
    html_options = {}
    html_options.merge!(style_classes)

    html_options.merge!(remote_link_options) if remote?
    html_options.merge!(trigger_options) if trigger?

    html_options
  end

  def remote?
    remote
  end

  def trigger?
    trigger
  end


  private

  def style_classes
    link_style = "e-button"
    link_style << " #{style}" if style.present?
    link_style << " #{trigger}" if trigger?

    { class: link_style }
  end

  def remote_link_options
    {
      remote: true,
      rel: "noopener noreferer"
    }
  end

  def trigger_options
    { type: "Button" }
  end
end
