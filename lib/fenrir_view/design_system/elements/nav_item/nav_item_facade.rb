class NavItemFacade < FenrirView::Presenter
  properties :title, :link, :style, :current_page

  def title
    properties[:title].titleize
  end

  def style
    link_style = properties[:style] || "c-text--note"
    link_style << " e-nav-item__link"
    link_style << " u-color--success" if active?

    link_style
  end

  def linked?
    link.present?
  end

  def active?
    properties[:current_page] == link
  end
end
