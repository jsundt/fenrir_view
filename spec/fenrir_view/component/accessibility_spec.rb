# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::Component::Accessibility do
  subject { described_class.new(component: 'a_component') }

  let(:audit_item) { OpenStruct.new({ id: 'test', scoreDisplayMode: 'numeric', score: 0.5 }) }

  before { allow(subject).to receive(:accessibility_report) { report } }

  context 'with a report' do
    let(:report) do
      OpenStruct.new({
                       fetchTime: '2021-07-23T10:03:10.394Z',
                       audits: { something: audit_item }
                     })
    end

    describe '#accessibility_available?' do
      it 'returns false' do
        expect(subject.accessibility_available?).to be(true)
      end
    end

    describe '#report_date' do
      it 'returns a date time' do
        expect(subject.report_date).to eq(DateTime.parse('2021-07-23T10:03:10.394Z'))
      end
    end

    describe '#audit' do
      it 'returns an array of FenrirView::Component::Accessibility objects' do
        expect(subject.audit).to be_instance_of(Array)
        expect(subject.audit.first).to be_instance_of(FenrirView::Component::AccessibilityIssue)
      end
    end
  end

  context 'without a report' do
    let(:report) { {} }

    describe '#accessibility_available?' do
      it 'returns false' do
        expect(subject.accessibility_available?).to be(false)
      end
    end

    describe '#report_date' do
      it 'returns nil' do
        expect(subject.report_date).to be_nil
      end
    end

    describe '#audit' do
      it 'returns nil' do
        expect(subject.audit).to be_nil
      end
    end
  end
end
