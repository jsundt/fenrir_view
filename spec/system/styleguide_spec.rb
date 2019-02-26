# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Styleguide', type: :system do
  describe 'documentation pages' do
    it 'can visit pages' do
      visit '/design_system'

      expect(current_path).to eq('/design_system/overview/index')
      expect(page).to have_text('Charlie Design')
      expect(page).to have_text('Select one of the components from the side to view its examples and documentation')

      # Links to documentation pages
      expect(page).to have_text('Welcome')
      expect(page).to have_text('Example usage')
      expect(page).to have_text('Broken properties')
      expect(page).to have_text('Other useful information')

      # Links to component pages
      expect(page).to have_text('Card')
      expect(page).to have_text('Header')
      expect(page).to have_text('Paragraph')
      expect(page).to have_text('Profile')
      expect(page).to have_text('Yielder')

      click_on 'Example usage'

      expect(page).to have_text('Examples of components together')
      expect(page).to have_selector('div.card', count: 3)
      expect(page).to have_text('Blocks of content yielded for days and days and days.')

      click_on 'Component yields'
      expect(page).to have_text('First layout component column1')
      expect(page).to have_text('First layout component column2')
      expect(page).to have_text('Second layout component column2')
      expect(page).to have_text('Second layout component column2')
      expect(page).to have_text('Nested layout component')
      expect(page).to have_text('Profile')
      expect(page).to have_text('Sam')

      expect(page).to_not have_text('WILL NOT RENDER')
      expect(page).to_not have_text('Second layout component column1')
    end

    xit 'can visit page missing content' do
      visit '/design_system/spec/missing'

      expect(page).to have_text('Missing Page')
    end
  end

  describe 'components' do
    it 'overview page' do
      visit '/design_system/components'
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
      expect(page).to have_text('badges: []')
      expect(page).to have_text('E.g. Charlie account badges. Is passed to icon helper.')
      expect(page).to have_text("<%= ui_component('profile', {properties as below}) %>")

      # TODO: Default properties table only shows up if the :meta key is part of yml
    end

    it 'shows a hint message if the component stub file is empty' do
      visit '/design_system/components/breadcrumbs'

      expect(page).to have_text('Hint:To see your component make sure you\'ve created stubs:')
      expect(page).to have_text('components/breadcrumbs/breadcrumbs.yml')
      expect(page).to have_text('information about the component breadcrumbs')
    end

    it 'shows a hint message if the component stub file is not found' do
      visit '/design_system/components/paragraph'

      expect(page).to have_text('Hint:To see your component make sure you\'ve created stubs:')
      expect(page).to have_text('components/paragraph/paragraph.yml')
      expect(page).to have_text('information about the component paragraph')
    end

    xit 'shows a hint message if the component is not found' do
      visit '/design_system/components/something'

      # TODO: differnt hint message if component is missing compared to just missing stubs
    end
  end

  describe 'system components' do
    it 'does not show in styleguide sidebar' do
      visit '/design_system'

      expect(page).to_not have_text('Application frame')
    end

    it 'accessible on direct url' do
      visit '/design_system/system_components/application_frame'

      expect(page).to have_text('Application frame')
    end
  end

  describe 'styleguide filter' do
    it 'can filter the sidebar' do
      visit '/design_system'

      expect(page).to have_text('Other useful information')
      expect(page).to_not have_text('Nothing found.')

      fill_in('stupid-filter-search', with: 'example')
      expect(page).to have_text('Example usage')
      expect(page).to_not have_text('Other useful information')

      fill_in('stupid-filter-search', with: 'garbage')
      expect(page).to have_text('Nothing found.')
      expect(page).to_not have_text('Example usage')

      fill_in('stupid-filter-search', with: 'u-color')
      expect(page).to_not have_text('Other useful information')
      click_on 'Example usage'

      expect(page).to have_text('Examples of components together')
    end
  end
end
