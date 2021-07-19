# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::Component::AccessibilityIssue do
  subject { described_class.new(issue: issue) }

  let(:issue) { OpenStruct.new(issue_hash) }
  let(:issue_hash) do
    {
      id: 'something-is-wrong',
      score: 0.5,
      scoreDisplayMode: 'numeric',
      title: 'Something is Wrong',
      description: 'This is wrong. [Read more](https://example.org).'
    }
  end

  describe 'display?' do
    FenrirView::Component::AccessibilityIssue::EXCLUDED_IDS.each do |id|
      it "returns false when display id is #{id}" do
        issue_hash[:id] = id
        expect(subject.display?).to be(false)
      end
    end

    FenrirView::Component::AccessibilityIssue::EXCLUDED_DISPLAY_MODES.each do |mode|
      it "returns false when display mode is #{mode}" do
        issue_hash[:scoreDisplayMode] = mode
        expect(subject.display?).to be(false)
      end
    end

    context 'when scoreDisplayMode is binary' do
      it 'returns false when score is 1' do
        issue_hash[:scoreDisplayMode] = 'binary'
        issue_hash[:score] = 1
        expect(subject.display?).to be(false)
      end

      it 'returns true when score is 0' do
        issue_hash[:scoreDisplayMode] = 'binary'
        issue_hash[:score] = 0
        expect(subject.display?).to be(true)
      end
    end

    context 'when scoreDisplayMode is numeric' do
      it 'returns false when score is 1' do
        issue_hash[:score] = 1
        expect(subject.display?).to be(false)
      end

      it 'returns true when score is less than 1' do
        expect(subject.display?).to be(true)
      end
    end
  end

  describe '#show_score?' do
    it 'returns true when scoreDisplayMode is numeric' do
      expect(subject.show_score?).to be(true)
    end

    it 'returns false when scoreDisplayMode is binary' do
      issue_hash[:scoreDisplayMode] = 'binary'
      issue_hash[:score] = 1
      expect(subject.display?).to be(false)
    end
  end

  describe '#description' do
    it 'converts Markdown links to HTML links' do
      expect(subject.description).to eq('This is wrong. <a href="https://example.org" target="_blank" rel="noopener noreferrer">Read more</a>.')
    end
  end
end

# A simple mock of ActiveModel::Type::Boolean. AccessibilityIssue uses this to
# convert boolean-ish values into actual booleans but it's not available here.
module ActiveModel
  module Type
    class Boolean
      def serialize(val)
        val == 1
      end
    end
  end
end
