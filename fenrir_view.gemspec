$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fenrir_view/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fenrir_view"
  s.version     = FenrirView::VERSION
  s.authors     = ["Ignacio Gutierrez", "Esteban Pastorino"]
  s.email       = ["nachojgutierrez@gmail.com", "ejpastorino@gmail.com"]
  s.homepage    = "http://github.com/jsundt/fenrir_view"
  s.summary     = "Living styleguide, based on Mountain View by Ignacio Gutierrez and Esteban Pastorino."
  s.description = "Living styleguide, based on Mountain View by Ignacio Gutierrez and Esteban Pastorino."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0"
end
