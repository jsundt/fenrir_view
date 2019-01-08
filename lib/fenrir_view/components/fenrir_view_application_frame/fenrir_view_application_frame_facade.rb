# frozen_string_literal: true

class FenrirViewApplicationFrameFacade < FenrirView::Presenter
  property :page

  def navbar_facade
    {
      logo: {
        name: I18n.t('fenrir_view.styleguide_title'),
        link: fenrir_view_routes.root_path,
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
    page.docs.map do |section|
      {
        name: section.title,
        items: section.pages.map do |page|
          {
            title: page.title,
            link: fenrir_view_routes.fenrir_docs_path(section: section.folder, page: page.path),
            filter_types: page.filter_types,
          }
        end,
      }
    end
  end

  def component_links
    page.components.map do |section, data|
      {
        name: section.titleize,
        items: data.map do |component|
          {
            title: component.title,
            link: fenrir_view_routes.components_path(variant: section, id: component.name),
            filter_types: component.filter_types,
          }
        end
      }
    end
  end

  def system_component_links
    [{
      name: 'Internal system',
      style: 'u-opacity--50',
      items: page.system_components.map do |component|
        {
          title: component.title,
          link: fenrir_view_routes.system_components_path(id: component.name),
          filter_types: component.filter_types,
        }
      end
    }]
  end

  def fenrir_view_routes
    FenrirView::Engine.routes.url_helpers
  end
end
