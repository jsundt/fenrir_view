# frozen_string_literal: true

require 'fenrir_view/component'
require 'fenrir_view/component/accessibility_issue'
require 'fenrir_view/component/accessibility_overview'
require 'fenrir_view/component/accessibility'
require 'fenrir_view/component/examples'
require 'fenrir_view/component/health'
require 'fenrir_view/configuration'
require 'fenrir_view/documentation'
require 'fenrir_view/metrics'
require 'fenrir_view/presenter'
require 'fenrir_view/property_types'
require 'fenrir_view/version'

module FenrirView
  def self.pattern_type(variant)
    if variant == 'system'
      Pathname.new(File.expand_path('fenrir_view/components', __dir__))
    else
      FenrirView.configuration.system_path.join(variant)
    end
  end

  def self.patterns_for(variant)
    FenrirView.pattern_type(variant).join('*')
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require 'fenrir_view/engine' if defined?(Rails)
