FenrirView::Engine.routes.draw do
  root to: "docs#index"

  resources :styleguide, only: [:index, :show], path: FenrirView.configuration.styleguide_path

  get 'docs/:section(/:page)', to: 'docs#show', as: 'fenrir_docs'
end
