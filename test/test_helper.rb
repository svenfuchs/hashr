require 'bundler/setup'
require 'minitest/autorun'
require 'test_declarative'
require 'hashr'
require_relative 'test_support'

module Minitest
  class Test
    include TestSupport
  end
end
