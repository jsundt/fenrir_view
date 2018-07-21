# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::Generators::NewPatternGenerator, type: :system do
  before(:context) do
    system "cd test/dummy; rails g fenrir_view:new_pattern component widget"
  end

  after(:context) do
    system 'cd test/dummy/lib/design_system/components/widget; rm _widget.html.erb'
    system 'cd test/dummy/lib/design_system/components/widget; rm widget_facade.rb'
    system 'cd test/dummy/lib/design_system/components/widget; rm widget.js'
    system 'cd test/dummy/lib/design_system/components/widget; rm widget.scss'
    system 'cd test/dummy/lib/design_system/components/widget; rm widget.yml'
    system 'cd test/dummy/lib/design_system/components; rmdir widget'
  end

  let(:component_location) { "#{Rails.root}/lib/design_system/components/widget/" }

  it 'creates new component files' do
    expect(File).to exist(component_location + '_widget.html.erb')
    expect(File).to exist(component_location + 'widget_facade.rb')
    expect(File).to exist(component_location + 'widget.js')
    expect(File).to exist(component_location + 'widget.scss')
    expect(File).to exist(component_location + 'widget.yml')
  end

  xit 'raises error if you try to use an existing component name' do
    expect { system "cd test/dummy; rails g fenrir_view:new_pattern component widget" }.to raise_error
  end

  it 'can visit the new component page' do
    visit '/design_system/styleguide/component/widget'

    expect(page).to have_text('meta: \'information about the component widget\'')
  end

  xit 'generates new css files' do
    visit '/assets/components.scss'

    expect(page).to have_text('.c-widget')
  end

  xit 'generates new js files' do
    visit '/assets/components.js'

    expect(page).to have_text('.js-widget')
  end

  xit 'loads the new component facade' do
    expect(WidgetFacade).to be_a_kind_of(FenrirView::Presenter)
  end
end
