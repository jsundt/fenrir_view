class CardFacade < FenrirView::Presenter
  include ActionView::Helpers::TagHelper

  property :title, required: true
  property :description
  property :link
  property :image_url
  property :location
  property :data, default: []

  def title
    [location, properties[:title]].compact.join(", ")
  end

  def has_description?
    description.present?
  end
end
