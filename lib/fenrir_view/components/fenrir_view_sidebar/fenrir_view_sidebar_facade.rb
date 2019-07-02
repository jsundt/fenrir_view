# frozen_string_literal: true

class FenrirViewSidebarFacade < FenrirView::Presenter
  ### Required properties
  property :categories # Array of hashes

  ### Optional properties
  property :style

  def item_classes
    item_classes = ['fenrir-view-sidebar', 'js-fenrir-view-sidebar']
    item_classes.push(style) if style?

    item_classes.join(' ')
  end

  def category_facades
    @category_facades ||= properties[:categories].map do |category|
      Category.new(category: category)
    end
  end

  private

  def style?
    !!style
  end

  class Category
    def initialize(category:)
      @category = category
    end

    def name
      @category[:name]
    end

    def items
      @items ||= @category[:items].map do |item|
        Item.new(item: item)
      end
    end

    def style
      [
        'fenrir-view-sidebar__category',
        'js-fenrir-view-sidebar__category',
        @category[:style],
      ].join(' ')
    end

    def name?
      !!name
    end

    class Item
      def initialize(item:)
        @item = item
      end

      def title
        @item[:title]
      end

      def link
        @item[:link]
      end

      def filter_types
        @item[:filter_types]
      end

      def locked?
        @item[:locked]
      end
    end
  end
end
