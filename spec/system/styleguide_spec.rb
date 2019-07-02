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

      within('[data-spec-section="sidebar-test-cases"]') do
        expect(page).to have_text('No file')
        expect(page).to have_text('Example usage')
        expect(page).to have_text('Broken properties')
        expect(page).to have_text('Component yields')
        expect(page).to have_text('Locked page')
      end

      within('[data-spec-section="sidebar-system-information"]') do
        expect(page).to have_text('Other useful information')
      end

      # Links to component pages
      within('[data-spec-section="sidebar-components"]') do
        expect(page).to have_text('Breadcrumbs')
        expect(page).to have_text('Card')
        expect(page).to have_text('Header')
        expect(page).to have_text('Layout')
        expect(page).to have_text('Paragraph')
        expect(page).to have_text('Profile')
        expect(page).to have_text('Yielder')
      end

      click_on 'Example usage'
      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Examples of components together')
        expect(page).to have_selector('div.card', count: 3)
        expect(page).to have_text('Blocks of content yielded for days and days and days.')
      end

      click_on 'Component yields'
      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('First layout component column1', count: 1)
        expect(page).to have_text('First layout component column2', count: 1)
        expect(page).to_not have_text('First layout component block content', count: 1)

        expect(page).to have_text('Second layout component column2', count: 1)

        expect(page).to_not have_text('Layout component no block variable block content', count: 1)

        expect(page).to have_text('Nested layout component', count: 1)
        expect(page).to have_text('Profile', count: 1)
        expect(page).to have_text('Sam', count: 1)

        expect(page).to_not have_text('WILL NOT RENDER')
        expect(page).to_not have_text('Second layout component column1')
      end
    end

    it 'can only visit locked pages if you have permission' do
      visit '/design_system/spec/locked_page'

      expect(page).to_not have_text('Secret text')
      expect(page).to have_text('This page is restricted to Charlie employees')

      click_on 'Example usage'
      expect(page).to_not have_text('This content is only for employee\'s')

      allow_any_instance_of(DesignSystemPolicy).to receive(:employee?).and_return(true)

      visit '/design_system/spec/locked_page'

      expect(page).to have_text('Secret text')

      click_on 'Example usage'
      expect(page).to have_text('This content is only for employee\'s')
    end

    xit 'can visit page missing content' do
      visit '/design_system/spec/missing'

      expect(page).to have_text('Missing Page')
    end
  end

  describe 'components' do
    it 'overview page' do
      visit '/design_system/components'
      expect(page).to have_text('Pattern Library')
    end

    it 'show specific components' do
      visit '/design_system'
      click_on 'Card'

      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Healthy instances: 11')
        expect(page).to have_text('Property hashes: 0')
        expect(page).to have_text('Deprecated instances: 2')

        expect(page).to have_text('Aspen, Snowmass')
        expect(page).to have_text('title: "Snowmass"')
        expect(page).to have_text('link: "http://google.com"')
        expect(page).to have_selector('div.card', count: 3)
      end

      click_on 'Header'
      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('20 Mountains you didn\'t know they even existed')
        expect(page).to have_text('Header 1')
      end

      click_on 'Layout'
      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Healthy instances: 6')

        expect(page).to have_text('Layout component options')
        expect(page).to have_text('<% layout.column1 do %> <html> <% end %>')

        expect(page).to have_text('Without layout sections')
        expect(page).to have_text('With layout sections')
        expect(page).to have_text('With layout sections and classic yield')
        expect(page).to have_text('With only one section used')
        expect(page).to have_text('}) do |layout| %>')
        expect(page).to have_text('<% layout.column1 do %>')
      end

      click_on 'Yielder'
      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Regular yielder')
        expect(page).to have_text('Test yield', count: 2)
      end
    end

    it 'shows default properties and validations for specific component' do
      visit '/design_system'
      click_on 'Profile'

      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Low usage!')
        expect(page).to have_text('Health: 100%')
        expect(page).to have_text('Deprecated instances: 0')

        expect(page).to have_text('Component Properties:')
        expect(page).to have_text('name. Required. As String')
        expect(page).to have_text('badges: []')
        expect(page).to have_text('E.g. Charlie account badges. Is passed to icon helper.')
        expect(page).to have_text("<%= ui_component('profile', {\n  name: \"Johnny\"")
      end
    end

    it 'shows a hint message if the component stub file is empty' do
      visit '/design_system/components/breadcrumbs'

      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Low usage!')
        expect(page).to have_text('Health: 0%')

        expect(page).to have_text('Hint:To see your component make sure you\'ve created stubs:')
        expect(page).to have_text('components/breadcrumbs/breadcrumbs.yml')
        expect(page).to have_text('information about the component breadcrumbs')
      end
    end

    it 'shows a hint message if the component stub file is not found' do
      visit '/design_system/components/paragraph'

      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Hint:To see your component make sure you\'ve created stubs:')
        expect(page).to have_text('components/paragraph/paragraph.yml')
        expect(page).to have_text('information about the component paragraph')
      end
    end

    xit 'shows a hint message if the component is not found' do
      visit '/design_system/components/something'

      # TODO: differnt hint message if component is missing compared to just missing stubs
    end
  end

  describe 'system components' do
    it 'visible in sidebar' do
      visit '/design_system'

      expect(page).to have_text('Application frame')
      expect(page).to have_text('Button')
      expect(page).to have_text('Navbar')
      expect(page).to have_text('Sidebar')

      click_on 'Button'
      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('A navigation link or action trigger')
        expect(page).to have_text('Restyled button')
        expect(page).to have_text('Get Started!')
        expect(page).to have_text('GET STARTED!')
      end

      click_on 'Navbar'
      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Navbar')
        expect(page).to have_text('This is component is only available in the styleguide.')
      end

      click_on 'Sidebar'
      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Sidebar')
        expect(page).to have_text('This is component is only available in the styleguide.')
      end
    end

    it 'accessible on direct url' do
      visit '/design_system/system_components/application_frame'

      within('[data-spec-section="content-card"]') do
        expect(page).to have_text('Application frame')
        expect(page).to have_text('You have Stubs but they don\'t follow the correct format')
      end
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
