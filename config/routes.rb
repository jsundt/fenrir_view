FenrirView::Engine.routes.draw do
  root to: "styleguide#index"

  resources :styleguide, only: [:index, :show], path: FenrirView.configuration.styleguide_path
end
