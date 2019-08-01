# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::StyleguideFacade do
  let(:styleguide_facade) { FenrirView::StyleguideFacade.new(design_system_policy: DesignSystemPolicy.new) }
  let(:first_doc) { styleguide_facade.docs.first }
  let(:components) { styleguide_facade.components }

  it '#docs generate correct list of pages' do
    expected_doc_title = 'Overview'

    expect(first_doc).to be_a_kind_of(FenrirView::Documentation::Section)
    expect(first_doc.title).to eq(expected_doc_title)

    second_section = styleguide_facade.docs.second
    expected_section_title = 'Test cases'
    expected_section_slug = 'spec'

    expect(second_section).to be_a_kind_of(FenrirView::Documentation::Section)
    expect(second_section.title).to eq(expected_section_title)
    expect(second_section.folder).to eq(expected_section_slug)
    expect(second_section.pages.length).to eq(5)

    expect(second_section.pages.second).to be_a_kind_of(FenrirView::Documentation::Page)
    expect(second_section.pages.second.title).to eq('Example usage')
    expect(second_section.pages.second.path).to eq('examples')
  end

  it '#components generate correct list of components' do
    expect(components.count).to eq(7)
    expect(components.first).to be_a_kind_of(FenrirView::Component)

    card_component = components.second
    expected_component = FenrirView::Component.new('component', 'card')

    expect(card_component.title).to eq(expected_component.title)
  end
end
