# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'hashr/version'

Gem::Specification.new do |s|
  s.name         = "hashr"
  s.version      = Hashr::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "me@svenfuchs.com"
  s.homepage     = "http://github.com/svenfuchs/hashr"
  s.summary      = "Simple Hash extension to make working with nested hashes (e.g. for configuration) easier and less error-prone"
  s.description  = "#{s.summary}."
  s.license      = "MIT"

  s.files        = Dir['{lib/**/*,spec/**/*,MIT-LICENSE,README.md,Gemfile}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
