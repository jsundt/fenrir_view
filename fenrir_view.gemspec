# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'fenrir_view/version'

Gem::Specification.new do |s|
  s.name        = 'fenrir_view'
  s.version     = FenrirView::VERSION
  s.authors     = ['Joergen Sundt']
  s.email       = ['jorgen@charliehr.com']
  s.homepage    = 'http://github.com/jsundt/fenrir_view'
  s.summary     = 'Charlie\'s design documentation and living pattern library.'
  s.description = 'Based on the Mountain View rails gem by Ignacio Gutierrez and Esteban Pastorino.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*', 'spec/**/*']

  s.add_dependency 'rails', '>= 6.0.0'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'json'
  s.add_development_dependency 'rspec-rails', '~> 4'
  s.add_development_dependency 'webdrivers', '~> 4.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
end
