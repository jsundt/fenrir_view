# frozen_string_literal: true

class <%= component_name.camelize %>Facade < FenrirView::Presenter
  property :title, default: 'The best title', required: true, one_of_type: [String]

  # property :description, one_of: ['The best description', 'The second best description'], note: 'Change these rules'
  # property :items, hash_of: {
  #   id: { required: true },
  #   archived: { defualt: false, one_of_type: [TrueClass, FalseClass], required: true },
  #   tags: { array_of: { one_of_type: [Hash] } }
  # }

  property :style

  # property :design_system_tags, default: []   # Component: Tag

  def item_classes
    item_classes = ["<%= css_class_name %>", "<%= js_class_name %>"]
    item_classes.push(style) if style?

    item_classes.join(" ")
  end

  def style?
    !!style
  end

  # def tags?
  #   design_system_tags.any?
  # end

  ## Layout section Handling
  ## Block content is available in partial as: properties[:yield]
  ## Pass multiple blocks of html to this component by uncommenting the below
  # attr_reader :layout

  ## Layout is set by the ui_component helper (context = ui_component: self)
  ## This is required for capture to later get the block content from the view
  # def layout=(context)
  #   @layout = LayoutSectionCollector.new(context: context)
  # end

  ## Layout sections should be the same as the method names defined in
  ## LayoutSectionCollector. This is used by the style guide documentation.
  # VALID_LAYOUT_SECTIONS = %i[column1 column2 add_item]

  # def layout_item?(item_id:)
  #   !!layout && layout.item?(item_id: item_id)
  # end

  # def layout_items?
  #   !!layout && layout.items?
  # end

  ## The LayoutSectionCollector is used by the yield statement in
  ## ui_component to allow the component access to anything passed
  ## to the layout block argument.
  ##
  ## The defined methods in this class is available in the view,
  ## and used by the component partial to render the content in the
  ## correct area.
  ##
  # class LayoutSectionCollector
  #   def initialize(context:)
  #     @context = context
  #     @items = {}
  #   end

  #   def column1(&block)
  #     @column1 ||= block_given? ? @context.capture(&block) : nil
  #   end

  #   def column2(&block)
  #     @column2 ||= block_given? ? @context.capture(&block) : nil
  #   end

  #   def items?
  #     @items.any?
  #   end

  #   def item?(item_id:)
  #     @items[item_id].present?
  #   end

  #   def render_item(item_id:)
  #     @items[item_id]
  #   end

  #   def add_item(item_id:, &block)
  #     @items[item_id] = @context.capture(&block) if block_given?
  #   end
  # end
end
