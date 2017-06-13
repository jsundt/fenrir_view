$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fenrir_view/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fenrir_view"
  s.version     = FenrirView::VERSION
  s.authors     = ["Jørgen Sundt"]
  s.email       = ["jorgen@charliehr.com"]
  s.homepage    = "http://github.com/jsundt/fenrir_view"
  s.summary     = "Charlie's design documentation and living pattern library."
  s.description = "Based on the Mountain View rails gem by Ignacio Gutierrez and Esteban Pastorino."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0"
  # s.add_dependency "sass-rails", "~> 5.0"
  # s.add_dependency "jquery-rails"
  # s.add_dependency "jquery-ui-rails", "~> 6.0"
end
