# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::Configuration do
  let(:initilized_configuration) { FenrirView.configuration }

  describe '#styleguide_path' # TODO: Remove this, not in use

  describe '#system_variants' do
    let(:default_system_variants) { ['elements', 'components', 'modules', 'views'] }
    let(:custom_system_variants) { ['components', 'views'] }

    it 'Set default system variants' do
      expect(initilized_configuration.system_variants).to eq(default_system_variants)
    end

    it 'You can change system variants' do
      FenrirView.configure { |c| c.system_variants = custom_system_variants }
      expect(FenrirView.configuration.system_variants).to eq(custom_system_variants)

      FenrirView.configure { |c| c.system_variants = default_system_variants }
      expect(FenrirView.configuration.system_variants).to eq(default_system_variants)
    end
  end

  describe '#system_path' do
    let(:default_system_path) { Rails.root.join('lib', 'design_system') }
    let(:custom_system_path) { Rails.root.join('app', 'ds') }

    it 'Set default system path' do
      expect(initilized_configuration.system_path).to eq(default_system_path)
    end

    it 'You can change system path' do
      FenrirView.configure { |c| c.system_path = custom_system_path }
      expect(FenrirView.configuration.system_path).to eq(custom_system_path)
      expect(FenrirView.pattern_type('components')).to eq(custom_system_path.join('components'))
      expect(FenrirView.patterns_for('components')).to eq(custom_system_path.join('components', '*'))

      FenrirView.configure { |c| c.system_path = default_system_path }
      expect(FenrirView.configuration.system_path).to eq(default_system_path)
      expect(FenrirView.pattern_type('components')).to eq(default_system_path.join('components'))
    end
  end

  describe '#docs_path' do
    let(:default_docs_path) { FenrirView.configuration.system_path.join('docs') }
    let(:custom_docs_path) { FenrirView.configuration.system_path.join('documentation') }

    it 'Set default docs path' do
      expect(initilized_configuration.docs_path).to eq(default_docs_path)
    end

    it 'You can change docs path' do
      FenrirView.configure { |c| c.docs_path = custom_docs_path }
      expect(FenrirView.configuration.docs_path).to eq(custom_docs_path)

      FenrirView.configure { |c| c.docs_path = default_docs_path }
      expect(FenrirView.configuration.docs_path).to eq(default_docs_path)
    end
  end

  describe '#property_validation' do
    let(:default_property_validation) { !Rails.env.production? }
    let(:custom_property_validation) { Rails.env.production? }

    it 'Set default property validation' do
      expect(initilized_configuration.property_validation).to eq(default_property_validation)
    end

    it 'You can change docs path' do
      FenrirView.configure { |c| c.property_validation = custom_property_validation }
      expect(FenrirView.configuration.property_validation).to eq(custom_property_validation)

      FenrirView.configure { |c| c.property_validation = default_property_validation }
      expect(FenrirView.configuration.property_validation).to eq(default_property_validation)
    end
  end
end
