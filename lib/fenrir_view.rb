require "fenrir_view/version"
require "fenrir_view/configuration"
require "fenrir_view/presenter"
require "fenrir_view/component"
require "fenrir_view/docs"

module FenrirView
  def self.root
    File.dirname __dir__
  end

  def self.pattern(variant)
    components = File.join(FenrirView.root, 'lib', 'fenrir_view', 'design_system', variant, '*').to_s
    sandbox = FenrirView.configuration.system_path.join(variant, '*').to_s

    [components, sandbox]
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require "fenrir_view/engine" if defined?(Rails)
