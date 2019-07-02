# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FenrirView::Metrics do
  subject { described_class.new }
  let(:path_to_metrics_file) { 'tmp/metrics.yml' }

  before do
    File.delete(path_to_metrics_file) if File.exist?(path_to_metrics_file)

    allow(subject).to receive(:puts).and_return(nil)
    allow(subject).to receive(:printf).and_return(nil)
    allow(subject).to receive(:metrics_file) do
      File.new(path_to_metrics_file, 'w')
    end
  end

  after do
    File.delete(path_to_metrics_file) if File.exist?(path_to_metrics_file)
  end

  it { expect { subject }.not_to raise_error }

  context 'when there is no metrics file' do
    it 'creates a new metrics file' do
      expect(File.exist?(path_to_metrics_file)).to eq(false)
      subject.run
      expect(File.exist?(path_to_metrics_file)).to eq(true)
      expect(File.readlines(path_to_metrics_file).size).to_not eq(0)
      expect(File.readlines(path_to_metrics_file)[1]).to eq(":design_system:\n")
    end
  end

  context 'when there is a metrics file' do
    before { File.open(path_to_metrics_file, 'w') }

    it 'overwrites the existing file' do
      expect(File.exist?(path_to_metrics_file)).to eq(true)
      expect(File.readlines(path_to_metrics_file).size).to eq(0)
      subject.run
      expect(File.exist?(path_to_metrics_file)).to eq(true)
      expect(File.readlines(path_to_metrics_file).size).to_not eq(0)
      expect(File.readlines(path_to_metrics_file)[1]).to eq(":design_system:\n")
    end
  end

  context 'For an empty app' do
    before do
      allow(subject).to receive(:facade_files).and_return([])
      allow(subject).to receive(:erb_files).and_return([])
      allow(subject).to receive(:system_files).and_return([])
      allow(subject).to receive(:scss_files).and_return([])
      allow(subject).to receive(:js_files).and_return([])

      subject.run
    end

    let(:metrics_yml) { YAML.load_file(path_to_metrics_file) }
    let(:metric_components) { metrics_yml.dig(:design_system, :metrics, :components) }
    let(:metric_totals) { metrics_yml.dig(:design_system, :metrics, :totals) }

    it 'calculates totals' do
      expect(metric_components.length).to eq(7)
      expect(metric_totals.dig(:components)).to eq(0)
      expect(metric_totals.dig(:saturation)).to eq(0)
    end
  end

  context 'For an app with components' do
    before do
      File.open('tmp/metrics_erb1.html.erb', 'a') do |f|
        f.write("<%= ui_component('card', {} %>\n<%= ui_component('card', {} %>")
      end

      File.open('tmp/metrics_erb2.html.erb', 'a') do |f|
        f.write("<%= ui_component('card', {} %>\n<%= ui_component('card', {} %>")
      end

      allow(subject).to receive(:facade_files).and_return([])
      allow(subject).to receive(:erb_files).and_return(['tmp/metrics_erb1.html.erb'])
      allow(subject).to receive(:system_files).and_return(['tmp/metrics_erb2.html.erb'])
      allow(subject).to receive(:scss_files).and_return([])
      allow(subject).to receive(:js_files).and_return([])

      subject.run
    end

    after do
      File.delete('tmp/metrics_erb1.html.erb') if File.exist?('tmp/metrics_erb1.html.erb')
      File.delete('tmp/metrics_erb2.html.erb') if File.exist?('tmp/metrics_erb2.html.erb')
    end

    let(:metrics_yml) { YAML.load_file(path_to_metrics_file) }
    let(:metric_components) { metrics_yml.dig(:design_system, :metrics, :components) }
    let(:metric_totals) { metrics_yml.dig(:design_system, :metrics, :totals) }

    it 'calculates totals' do
      expect(metric_components.length).to eq(7)
      expect(metric_totals.dig(:components)).to eq(4)
      expect(metric_totals.dig(:saturation)).to eq(100.0)
    end
  end

  context 'For an app with deprecated components' do
    before do
      File.open('tmp/metrics_erb1.html.erb', 'a') do |f|
        f.write([
          "<%= ui_component('card', {} %>",
        ].join("\n"))
      end

      File.open('tmp/metrics_erb2.html.erb', 'a') do |f|
        f.write([
          '<button>Deprecated button</button>',
          '<button>Deprecated button</button>',
          '<button>Deprecated button</button>',
        ].join("\n"))
      end

      allow(subject).to receive(:facade_files).and_return([])
      allow(subject).to receive(:erb_files) do
        [
          'tmp/metrics_erb1.html.erb',
          'tmp/metrics_erb2.html.erb',
        ]
      end
      allow(subject).to receive(:system_files).and_return([])
      allow(subject).to receive(:scss_files).and_return([])
      allow(subject).to receive(:js_files).and_return([])

      subject.run
    end

    after do
      File.delete('tmp/metrics_erb1.html.erb') if File.exist?('tmp/metrics_erb1.html.erb')
      File.delete('tmp/metrics_erb2.html.erb') if File.exist?('tmp/metrics_erb2.html.erb')
    end

    let(:metrics_yml) { YAML.load_file(path_to_metrics_file) }
    let(:metric_card) { metrics_yml.dig(:design_system, :metrics, :components, :card) }
    let(:metric_file_types) { metrics_yml.dig(:design_system, :metrics, :file_types) }
    let(:metric_totals) { metrics_yml.dig(:design_system, :metrics, :totals) }

    it 'finds files to parse' do
      expect(metric_file_types.dig(:erb, :files)).to eq(2)
      expect(metric_file_types.dig(:erb, :lines)).to eq(4)

      expect(metric_file_types.dig(:facades, :files)).to eq(0)
      expect(metric_file_types.dig(:scss, :files)).to eq(0)
      expect(metric_file_types.dig(:js, :files)).to eq(0)
    end

    it 'sets component information' do
      expect(metric_card.dig(:component_count)).to eq(1)
      expect(metric_card.dig(:property_hash_count)).to eq(0)
      expect(metric_card.dig(:deprecated_instance_count)).to eq(3)
      expect(metric_card.dig(:composition_usage)).to eq(0)
    end

    it 'calculates totals' do
      expect(metric_totals.dig(:components)).to eq(1)
      expect(metric_totals.dig(:deprecated)).to eq(3)
      expect(metric_totals.dig(:saturation)).to eq(25.0)
    end
  end

  context 'For an app with property hashes' do
    let(:path_to_facade_file) { 'tmp/metrics_facade_1.rb' }

    before do
      File.open(path_to_facade_file, 'a') do |f|
        f.write([
          "DesignSystem.properties('card', {})",
          "DesignSystem.properties('card', {})",
          "DesignSystem.properties('card', {})",
        ].join("\n"))
      end

      allow(subject).to receive(:facade_files).and_return([path_to_facade_file])
      allow(subject).to receive(:erb_files).and_return([])
      allow(subject).to receive(:system_files).and_return([])
      allow(subject).to receive(:scss_files).and_return([])
      allow(subject).to receive(:js_files).and_return([])

      subject.run
    end

    after do
      File.delete(path_to_facade_file) if File.exist?(path_to_facade_file)
    end

    let(:metrics_yml) { YAML.load_file(path_to_metrics_file) }
    let(:metric_totals) { metrics_yml.dig(:design_system, :metrics, :totals) }

    it 'calculates totals' do
      expect(metric_totals.dig(:components)).to eq(0)
      expect(metric_totals.dig(:property_hashes)).to eq(3)
      expect(metric_totals.dig(:saturation)).to eq(100)
    end
  end

  context 'For an app with scss files' do
    let(:path_to_scss_file) { 'tmp/metrics_scss_file.scss' }

    before do
      File.open(path_to_scss_file, 'a') do |f|
        f.write([
          '// old classes',
          '.button {}',
          '.button:hover {}',
        ].join("\n"))
      end

      allow(subject).to receive(:facade_files).and_return([])
      allow(subject).to receive(:erb_files).and_return([])
      allow(subject).to receive(:system_files).and_return([])
      allow(subject).to receive(:scss_files).and_return([path_to_scss_file])
      allow(subject).to receive(:js_files).and_return([])

      subject.run
    end

    after do
      File.delete(path_to_scss_file) if File.exist?(path_to_scss_file)
    end

    let(:metrics_yml) { YAML.load_file(path_to_metrics_file) }
    let(:metric_scss) { metrics_yml.dig(:design_system, :metrics, :file_types, :scss) }
    let(:metric_totals) { metrics_yml.dig(:design_system, :metrics, :totals) }

    it 'finds classes in scss files' do
      expect(metric_scss.dig(:files)).to eq(1)
      expect(metric_scss.dig(:lines)).to eq(3)
      expect(metric_scss.dig(:classes)).to eq(2)
    end

    it 'calculates totals' do
      expect(metric_totals.dig(:components)).to eq(0)
      expect(metric_totals.dig(:saturation)).to eq(0)
    end
  end

  context 'For an app with js files' do
    let(:path_to_js_file) { 'tmp/metrics_js_file.js' }

    before do
      File.open(path_to_js_file, 'a') do |f|
        f.write([
          '// old javascript',
          'function(){}',
          'function loadThing() {}',
          'function addButton(text, link) {}',
        ].join("\n"))
      end

      allow(subject).to receive(:facade_files).and_return([])
      allow(subject).to receive(:erb_files).and_return([])
      allow(subject).to receive(:system_files).and_return([])
      allow(subject).to receive(:scss_files).and_return([])
      allow(subject).to receive(:js_files).and_return([path_to_js_file])

      subject.run
    end

    after do
      File.delete(path_to_js_file) if File.exist?(path_to_js_file)
    end

    let(:metrics_yml) { YAML.load_file(path_to_metrics_file) }
    let(:metric_js) { metrics_yml.dig(:design_system, :metrics, :file_types, :js) }
    let(:metric_totals) { metrics_yml.dig(:design_system, :metrics, :totals) }

    it 'finds classes in scss files' do
      expect(metric_js.dig(:files)).to eq(1)
      expect(metric_js.dig(:lines)).to eq(4)
      expect(metric_js.dig(:functions)).to eq(3)
    end

    it 'calculates totals' do
      expect(metric_totals.dig(:components)).to eq(0)
      expect(metric_totals.dig(:saturation)).to eq(0)
    end
  end
end
