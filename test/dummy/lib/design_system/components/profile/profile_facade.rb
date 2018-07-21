class ProfileFacade < FenrirView::Presenter
  property :name, required: true, one_of_type: [String]

  ### Optional properties
  property :description, one_of_type: [String]
  property :status, default: 'default', one_of: ['default', 'danger', 'warning', 'success', 'primary']
  property :avatar, one_of_type: [String]
  property :link, one_of_type: [String]
  property :size, default: 'medium', one_of: ['small', 'medium']
  property :style, default: '', one_of_type: [String]
  property :loader, default: false, one_of_type: [TrueClass, FalseClass]
  property :remote, default: false, one_of_type: [TrueClass, FalseClass]

  property :badges, default: [], array_of: { one_of_type: [String] }, note: 'E.g. Charlie account badges. Is passed to icon helper.'
  property :emoji, default: [], array_of: { one_of_type: [String] }
end
