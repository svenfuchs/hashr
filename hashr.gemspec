# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'hashr/version'

Gem::Specification.new do |s|
  s.name         = "hashr"
  s.version      = Hashr::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/hashr"
  s.summary      = "Simple Hash extension targetted at configuration"
  s.description  = "Simple Hash extension targetted at configuration."

  s.files        = Dir['{lib/**/*,test/**/*,[A-Z]*}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'test_declarative', '>=0.0.2'
end
