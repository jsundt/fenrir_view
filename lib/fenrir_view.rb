require "fenrir_view/version"
require "fenrir_view/configuration"
require "fenrir_view/presenter"
require "fenrir_view/component"

module FenrirView
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require "fenrir_view/engine" if defined?(Rails)
