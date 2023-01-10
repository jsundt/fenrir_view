# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::Presenter do
  describe 'Presenter class' do
    let(:mock_presenter_class) { FenrirView::Presenter.new(variant: 'component', slug: 'base', properties: {}, validate: false) }

    it 'initializes with correct variables' do
      expect(mock_presenter_class.variant).to eq('component')
      expect(mock_presenter_class.slug).to eq('base')
      expect(mock_presenter_class.properties).to eq({yield: nil})
    end

    it '#partial returns the correct path' do
      expect(mock_presenter_class.partial).to eq('base/base')
    end
  end

  describe '#component_for initilizes facade inheriting presenter' do
    let(:dummy_card_facade) {
      FenrirView::Presenter.component_for(variant: 'component', slug: 'card', properties: { title: 'everything' }, validate: false)
    }

    it 'finds correct component facade' do
      expect(dummy_card_facade).to be_a_kind_of(CardFacade)
      expect(dummy_card_facade.class.superclass).to be_a_kind_of(FenrirView::Presenter.class)
    end

    it 'initializes with correct variables' do
      expect(dummy_card_facade.variant).to eq('component')
      expect(dummy_card_facade.slug).to eq('card')
      expect(dummy_card_facade.properties).to eq({
        yield: nil,
        title: 'everything',
        description: nil,
        link: nil,
        image_url: nil,
        location: nil,
        data: [],
      })
      expect(dummy_card_facade.title).to eq('everything')
      expect(dummy_card_facade.has_description?).to eq(false)
    end

    it '#partial returns the correct path' do
      expect(dummy_card_facade.partial).to eq('card/card')
    end

    it '#component_property_rule_descriptions' do
      expect(dummy_card_facade.component_property_rule_descriptions).to eq({
        yield: {
          default: nil,
          note: nil,
          validations: { required: false },
        },
        title: {
          default: nil,
          note: nil,
          validations: { required: true },
        },
        description: {
          default: nil,
          note: nil,
          validations: { required: false },
        },
        link: {
          default: nil,
          note: nil,
          validations: { required: false },
        },
        image_url: {
          default: nil,
          note: nil,
          validations: { required: false },
        },
        location: {
          default: nil,
          note: nil,
          validations: { required: false },
        },
        data: {
          default: [],
          note: nil,
          validations: { required: false },
        },
      })
    end

    describe '#validate_properties' do
      let(:invalid_card_facade) {
        FenrirView::Presenter.component_for(variant: 'component', slug: 'card', properties: { not_a_property: 'everything' }, validate: false)
      }

      it 'validates correctly if validations are met' do
        expect { dummy_card_facade.send(:validate_properties) }.to_not raise_error
      end

      it 'raises error if validations are not met' do
        expect { invalid_card_facade.send(:validate_properties) }.to raise_error('CardFacade has unkown keys: not_a_property. Should be one of: yield, title, description, link, image_url, location, data')
      end
    end
  end
end
