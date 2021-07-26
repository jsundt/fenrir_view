# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::Component::AccessibilityOverview do
  subject do
    obj = described_class.new
    allow(obj).to receive(:report) { report }

    obj
  end

  let(:component_score) { OpenStruct.new({ 'accessibility': 0.96, 'best_practices': 0.93 }) }
  let(:report) { OpenStruct.new({ 'a_component': component_score }) }

  describe '#scores_for' do
    it 'returns a component\'s score' do
      expect(subject.scores_for('a_component')).to eq(component_score)
    end

    it 'returns nil when the component isn\'t found' do
      expect(subject.scores_for('bananas')).to be_nil
    end
  end
end
