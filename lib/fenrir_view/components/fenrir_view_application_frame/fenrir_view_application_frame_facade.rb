# frozen_string_literal: true

class FenrirViewApplicationFrameFacade < FenrirView::Presenter
  property :page

  def navbar_facade
    {
      logo: {
        name: I18n.t('fenrir_view.styleguide_title'),
        link: '/design_system',
        image: I18n.t('fenrir_view.styleguide_logo').presence,
      },
      sidebar: !!sidebar_facade,
    }
  end

  def sidebar_facade
    @sidebar_facade ||= { categories: sidebar_link_categories }
  end

  private

  def sidebar_link_categories
    links = doc_links + component_links
    links += system_component_links if Rails.env.development?

    links
  end

  def doc_links
    doc_links = page.docs.map do |doc|
      items = []

      doc.sections.each do |section|
        section.pages.each do |page|
          items.push({
            title: page.title,
            link: "/design_system/docs/#{page.section_path}/#{page.page_path}"
          })
        end
      end

      {
        name: doc.title,
        style: 'u-padding--b-50',
        items: items,
      }
    end

    doc_links
  end

  def component_links
    component_links = page.components.map do |section, data|
      items = data.map do |item|
        {
          title: item.title,
          link: "/design_system/styleguide/#{section}/#{item.name}"
        }
      end

      {
        name: section.titleize,
        style: 'u-padding--b-50',
        items: items,
      }
    end

    component_links
  end

  def system_component_links
    [{
      name: 'System components',
      style: 'u-padding--b-50',
      items: page.system_components.map do |item|
        {
          title: item.title,
          link: "/design_system/system_components/#{item.name}"
        }
      end,
    }]
  end
end
