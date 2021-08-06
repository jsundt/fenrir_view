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
                       audits: OpenStruct.new({ something: audit_item })
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

    describe '#screenshot' do
      context 'with no screenshot' do
        it 'returns nil' do
          expect(subject.screenshot).to be_nil
        end
      end

      context 'with a screenshot' do
        let(:screenshot) { OpenStruct.new({ details: OpenStruct.new({ screenshot: OpenStruct.new({ data: '123' }) }) }) }
        let(:report) do
          OpenStruct.new({
                           fetchTime: '2021-07-23T10:03:10.394Z',
                           audits: OpenStruct.new({ something: audit_item, 'full-page-screenshot': screenshot })
                         })
        end

        it 'returns the screenshot' do
          expect(subject.screenshot).to be_instance_of(FenrirView::Component::AccessibilityScreenshot)
        end
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

    describe '#audit_for_display' do
      it 'returns nil' do
        expect(subject.audit_for_display).to be_nil
      end
    end

    describe '#screenshot' do
      it 'returns nil' do
        expect(subject.screenshot).to be_nil
      end
    end
  end
end
