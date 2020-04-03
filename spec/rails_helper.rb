# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
  add_filter '/spec/'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../test/dummy/config/environment', __dir__)

require 'webdrivers/chromedriver'
require 'selenium-webdriver'
require 'rspec/rails'
require 'spec_helper'
