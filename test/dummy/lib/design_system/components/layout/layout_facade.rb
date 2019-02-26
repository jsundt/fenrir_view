# frozen_string_literal: true

class LayoutFacade < FenrirView::Presenter
  property :title

  # Layout section handling
  attr_reader :layout

  def build_layout_from_context(context)
    @layout = LayoutSectionCollector.new(context: context)
  end

  VALID_LAYOUT_SECTIONS = %i[column1 column2]

  class LayoutSectionCollector
    def initialize(context:)
      @context = context
    end

    def column1(&block)
      @column1 ||= block_given? ? @context.capture(&block) : nil
    end

    def column2(&block)
      @column2 ||= block_given? ? @context.capture(&block) : nil
    end
  end
end
