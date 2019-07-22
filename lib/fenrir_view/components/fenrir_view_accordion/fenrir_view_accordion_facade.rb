# frozen_string_literal: true

class FenrirViewAccordionFacade < FenrirView::Presenter
  property :title, required: true, one_of_type: [String]
  property :description, one_of_type: [String]
  property :style, default: 'u-bg--white', one_of_type: [String]
  property :icon, one_of_type: [String]
  property :open, default: false, one_of_type: [TrueClass, FalseClass]
  property :openable, default: true, one_of_type: [TrueClass, FalseClass]

  def item_classes
    item_classes = ['fenrir-view-accordion', 'js-fenrir-view-accordion']
    item_classes.push(style) if style?

    item_classes.join(' ')
  end

  def wrapper_attributes
    attributes = { class: item_classes }
    attributes['data-pre-open'] = true if open?
    attributes['data-openable'] = openable?

    attributes
  end

  def style?
    !!style
  end

  def icon?
    !!icon
  end

  def open?
    openable? && properties[:open]
  end

  def openable?
    properties[:openable] && yield?
  end

  def yield?
    properties[:yield].present?
  end

  def description?
    !!description
  end

  def arrow_icon
    if openable?
      {
        icon: 'arrow',
        style: 'fenrir-view-accordion__actions-arrow',
      }
    else
      {
        icon: 'lock',
      }
    end
  end

  def icon
    return false unless properties[:icon].present?

    {
      icon: properties[:icon],
    }
  end
end
