# frozen_string_literal: true

class CollectionFacade < FenrirView::Presenter
  property :title

  # Layout section handling
  attr_reader :layout

  def build_layout_from_context(context)
    @layout = LayoutSectionCollector.new(context: context)
  end

  VALID_LAYOUT_SECTIONS = %i[add_item].freeze

  class LayoutSectionCollector
    def initialize(context:)
      @context = context
      @items = []
    end

    def items?
      @items.any?
    end

    def render_items
      @items.compact
    end

    def add_item(&block)
      @items.push(@context.capture(&block)) if block_given?
    end
  end
end
