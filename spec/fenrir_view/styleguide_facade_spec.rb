# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::StyleguideFacade do
  let(:styleguide_facade) { FenrirView::StyleguideFacade.new }
  let(:first_doc) { styleguide_facade.docs.first }
  let(:components) { styleguide_facade.components }

  it '#docs generate correct list of pages' do
    expected_doc_title = 'System info'

    expect(first_doc).to be_a_kind_of(FenrirView::Docs)
    expect(first_doc.title).to eq(expected_doc_title)

    second_section = first_doc.sections.second
    expected_section_title = 'Spec'
    expected_section_path = 'spec'

    expect(second_section).to be_a_kind_of(FenrirView::DocSection)
    expect(second_section.title).to eq(expected_section_title)
    expect(second_section.path).to eq(expected_section_path)

    expect(second_section.pages.first).to be_a_kind_of(OpenStruct)
    expect(second_section.pages.first.title).to eq('Test cases')
    expect(second_section.pages.first.section_path).to eq('spec')
    expect(second_section.pages.first.page_path).to eq('index')
  end

  it '#components generate correct list of components' do
    expect(components.count).to eq(4)

    expect(components['elements'].first).to be_a_kind_of(FenrirView::Component)
    expect(components['components'].first).to be_a_kind_of(FenrirView::Component)
    expect(components['modules']).to be_empty
    expect(components['views']).to be_empty

    card_component = components['components'].second
    expected_component = FenrirView::Component.new('component', 'card')

    expect(card_component.title).to eq(expected_component.title)
  end
end
