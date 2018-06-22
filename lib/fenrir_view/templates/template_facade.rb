class <%= pattern_name.camelize %>Facade < FenrirView::Presenter
  ### Required properties
  property :title, required: true, one_of_type: [String], one_of: ['The best title', 'The second best title']

  ### Optional properties
  property :style

  ### Properties passed on to other patterns
  property :design_system_tags, default: []   # Element: Tag

  ### Block content is available in partial as: properties[:yield]

  def item_classes
    item_classes = ["<%= css_class_name %>", "<%= js_class_name %>"]
    item_classes.push(style) if style?

    item_classes.join(" ")
  end

  def style?
    !!style
  end

  def tags?
    design_system_tags.any?
  end
end
