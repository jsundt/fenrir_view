# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Asset generation', type: :system do
  it 'stylesheets find components css' do
    visit '/assets/components.css'

    expect(page).to have_text('.header')
    expect(page).to have_text('FenrirView: Component: yielder not found!')
  end

  it 'javascript find components js' do
    visit '/assets/components.js'

    expect(page).to have_text('console.log("header")')
    expect(page).to have_text('/* FenrirView: javascript not found for component \'yielder\'')
  end
end
