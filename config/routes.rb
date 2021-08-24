# frozen_string_literal: true

FenrirView::Engine.routes.draw do
  root to: 'docs#index'

  # Accessibility
  get 'front-end/accessibility', to: 'accessibility#index', as: 'accessibility_index'
  get 'front-end/accessibility/:page', to: 'accessibility#page', as: 'accessibility_page'

  # Component pages
  get 'components', to: 'styleguide#index', as: 'component_index'
  get 'components/:id', to: 'styleguide#show', as: 'components', defaults: { variant: 'components' }
  get 'components/:id/preview', to: 'styleguide#preview', as: 'preview', defaults: { variant: 'components' }

  # Custom documentation pages
  get ':section(/:page)', to: 'docs#show', as: 'fenrir_docs', constraints: FenrirView::Documentation.new
  get '/locked', to: 'docs#show_locked', as: 'fenrir_docs_locked'

  # Show components used by styleguide
  get 'system_components/:id', to: 'styleguide#show', as: 'system_components', defaults: { variant: 'system' }
end
