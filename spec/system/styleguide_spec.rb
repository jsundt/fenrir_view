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
      expect(page).to have_text('<%= ui_component("profile", {properties as below}) %>')

      # TODO: Default properties table only shows up if the :meta key is part of yml
    end

    it 'shows a hint message if the component stub file is empty' do
      visit '/design_system/components/components/breadcrumbs'

      expect(page).to have_text('Hint:To see your component make sure you\'ve created stubs:')
      expect(page).to have_text('components/breadcrumbs/breadcrumbs.yml')
      expect(page).to have_text('information about the component breadcrumbs')
    end

    it 'shows a hint message if the component stub file is not found' do
      visit '/design_system/components/components/paragraph'

      expect(page).to have_text('Hint:To see your component make sure you\'ve created stubs:')
      expect(page).to have_text('components/paragraph/paragraph.yml')
      expect(page).to have_text('information about the component paragraph')
    end

    xit 'shows a hint message if the component is not found' do
      visit '/design_system/components/components/something'

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
end
