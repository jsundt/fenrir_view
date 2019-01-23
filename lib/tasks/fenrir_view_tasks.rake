# frozen_string_literal: true

namespace :design_system do
  desc 'Generate a new design system metrics yaml file'
  task generate_metrics: :environment do
    FenrirView::Metrics.new.run
  end
end
