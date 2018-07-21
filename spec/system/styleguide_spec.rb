# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Styleguide', type: :system do
  describe 'documentation pages' do
    it 'can visit pages' do
      visit '/design_system'

      expect(current_path).to eq('/design_system/docs/overview/index')
      expect(page).to have_text('Charlie Design System')
      click_on 'Example Usage'

      expect(page).to have_text('Examples of components together')
      expect(page).to have_selector('div.card', count: 3)
      expect(page).to have_text('Blocks of content yielded for days and days and days.')
    end

    it 'can visit page missing content' do
      visit '/design_system/docs/spec/missing'

      expect(page).to have_text('Missing Page')
    end

    it 'raises error if a component on the page has broken properties' do
      expect { get '/design_system/docs/spec/broken' }.to raise_error('An instance of CardFacade is missing the required property: title')
    end
  end

  describe 'components' do
    xit 'overview page' do
      visit '/design_system/styleguide'
      # TODO: Fix broken page
    end

    it 'show specific component' do
      visit '/design_system'
      click_on 'Card'

      expect(page).to have_text('Aspen, Snowmass')
      expect(page).to have_text('title: "Snowmass"')
      expect(page).to have_text('link: "http://google.com"')
      expect(page).to have_selector('div.card', count: 3)
    end

    it 'shows default properties and validations for specific component' do
      visit '/design_system'
      click_on 'Profile'

      expect(page).to have_text('Component Properties:')
      expect(page).to have_text('name. Required. As String')
      expect(page).to have_text('validations: {
        one_of: [
          "default",
          "danger",
          "warning",
          "success",
          "primary"
        ]
      }')
      expect(page).to have_text('badges: []')
      expect(page).to have_text('E.g. Charlie account badges. Is passed to icon helper.')
      expect(page).to have_text('<%= ui_component("profile", {properties as below}) %>')

      # TODO: Default properties table only shows up if the :meta key is part of yml
    end

    it 'shows a hint message if the component stub file is empty' do
      visit '/design_system/styleguide/components/breadcrumbs'

      expect(page).to have_text('Hint:To see your component make sure you\'ve created stubs:')
      expect(page).to have_text('components/breadcrumbs/breadcrumbs.yml')
      expect(page).to have_text('information about the component breadcrumbs')
    end

    it 'shows a hint message if the component stub file is not found' do
      visit '/design_system/styleguide/components/paragraph'

      expect(page).to have_text('Hint:To see your component make sure you\'ve created stubs:')
      expect(page).to have_text('components/paragraph/paragraph.yml')
      expect(page).to have_text('information about the component paragraph')
    end

    xit 'shows a hint message if the component is not found' do
      visit '/design_system/styleguide/components/something'

      # TODO: differnt hint message if component is missing compared to just missing stubs
    end
  end
end
