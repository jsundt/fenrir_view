require "fenrir_view/version"
require "fenrir_view/configuration"
require "fenrir_view/property_types"
require "fenrir_view/presenter"
require "fenrir_view/component"
require "fenrir_view/docs"

module FenrirView
  def self.pattern_type(variant)
    FenrirView.configuration.system_path.join(variant)
  end

  def self.patterns_for(variant)
    FenrirView.configuration.system_path.join(variant, '*')
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require "fenrir_view/engine" if defined?(Rails)
