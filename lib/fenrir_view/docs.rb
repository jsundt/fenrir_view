module FenrirView
  class Docs
    attr_reader :name

    def initialize(name, sections)
      @name = name
      @sections = sections
    end

    def title
      @name.humanize
    end

    def sections
      @sections.map.with_index do |value, index|
        OpenStruct.new({
          id: index,
          title: value[1],
          path: value[0]
        })
      end
    end
  end
end
