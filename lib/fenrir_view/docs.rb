module FenrirView
  class Docs
    def initialize(name, sections)
      @name = name
      @sections = sections
    end

    def title
      @name.humanize
    end

    def sections
      @sections.map do |key, value|
        FenrirView::DocSection.new(key, value)
      end
    end
  end

  class DocSection
    def initialize(name, pages)
      @name = name
      @pages = pages
    end

    def title
      @name.humanize
    end

    def path
      @name
    end

    def pages
      @pages.map.with_index do |(key, value), index|
        OpenStruct.new({
          id: index,
          title: value.humanize,
          path: key
        })
      end
    end
  end
end
