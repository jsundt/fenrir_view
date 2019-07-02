# frozen_string_literal: true

module FenrirView
  class Documentation
    attr_reader :valid_pages

    def initialize
      @valid_pages = valid_documentation_pages
    end

    def sections
      @sections ||= documentation_pages_as_hash.map do |content|
        Section.new(content)
      end
    end

    def unlocked_sections
      @unlocked_sections ||= documentation_pages_as_hash.map do |section|
        unlocked_section_pages = []

        section.fetch(:pages).each do |page|
          unless page.fetch(:locked, true)
            unlocked_section_pages.push("#{section[:slug]}/#{page[:slug]}")
          end
        end

        unlocked_section_pages
      end.flatten
    end

    # Invalidate routes that does not match the described pages
    def matches?(request)
      section = request.path_parameters[:section]
      page = request.path_parameters[:page]

      valid_pages.key?(section) &&
        valid_pages[section].include?(page)
    end

    class Section
      def initialize(section)
        @section = section
      end

      def title
        @section[:title]
      end

      def folder
        @section[:slug]
      end

      def pages
        @pages ||= @section.fetch(:pages).map do |page|
          Page.new(page)
        end
      end
    end

    class Page
      def initialize(page)
        @page = page
      end

      def title
        @page[:title]
      end

      def path
        @page[:slug]
      end

      def filter_types
        [title, @page[:filter_types]].join(' ')
      end

      def locked
        @page.fetch(:locked, true)
      end
    end

    private

    def valid_documentation_pages
      permitted_pages = {}

      documentation_pages_as_hash.each do |section|
        facade = FenrirView::Documentation::Section.new(section)

        permitted_pages[facade.folder.to_s] = facade.pages.map { |page| page.path.to_s }
      end

      permitted_pages
    end

    def documentation_pages_as_hash
      @documentation_pages_as_hash ||= JSON.parse(JSON[documentation_pages], symbolize_names: true)
    end

    def documentation_pages
      yml_docs = YAML.load_file(documentation_file)
      yml_docs['documentation'] || []
    end

    def documentation_file
      FenrirView.configuration.docs_path.join('index.yml')
    end
  end
end
