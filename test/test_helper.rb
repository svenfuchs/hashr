require 'bundler/setup'
require 'minitest/autorun'
require 'test_declarative'
require 'hashr'
require 'test_support'

module Minitest
  class Test
    include TestSupport
  end
end
