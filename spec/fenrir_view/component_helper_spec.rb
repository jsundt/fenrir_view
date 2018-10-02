# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::ComponentHelper, type: :helper do
  let(:initilized_configuration) { FenrirView.configuration }

  describe '#ui_component' do
    it 'renders components from your app' do
      expect { helper.ui_component('card', { title: 'test' }) }.to_not raise_error
    end

    it 'does not render components from gem' do
      expect { helper.ui_component('application_frame', { title: 'test' }) }.to raise_error('Could not find component: components: application_frame')
    end
  end

  describe '#system_component' do
    it 'renders components from gem' do
      expect { helper.system_component('application_frame', { title: 'test' }) }.to_not raise_error
    end

    it 'does not render components from your app' do
      expect { helper.system_component('card', { title: 'test' }) }.to raise_error('Could not find component: system: fenrir_view_card')
    end
  end
end
