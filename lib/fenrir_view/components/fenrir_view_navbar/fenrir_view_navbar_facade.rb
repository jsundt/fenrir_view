# frozen_string_literal: true

class FenrirViewNavbarFacade < FenrirView::Presenter
  ### Required properties
  property :logo, default: { name: 'Charlie Design', style: '' }
  property :aria_label, default: 'Main menu'

  ### Optional properties
  property :theme, default: 'white' # 'charcoal' || 'white'
  property :style
  property :sidebar, default: false

  def item_classes
    item_classes = ['fenrir-view-navbar', 'js-fenrir-view-navbar']
    item_classes.push("theme-#{theme.downcase}")
    item_classes.push(style) if style?
    item_classes.push('has-tabs') if sidebar?

    item_classes.join(' ')
  end

  def additional_actions
    [
      {
        title: 'Go to Charlie',
        link: '/',
        style: 'u-bg--silver fenrir-view-navbar__action-button'
      }
    ]
  end

  def logo?
    !!properties[:logo]
  end

  def additional_actions?
    additional_actions.any?
  end

  def style?
    !!style
  end

  def sidebar?
    !!sidebar
  end
end
