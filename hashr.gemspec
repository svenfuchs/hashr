# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'hashr/version'

Gem::Specification.new do |s|
  s.name         = "hashr"
  s.version      = Hashr::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/hashr"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
