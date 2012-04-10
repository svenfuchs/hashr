require 'test_helper'

class CoreExtTest < Test::Unit::TestCase
  test 'Hash#deep_symbolize_keys walks arrays, too' do
    hash     = { 'foo' => [{ 'bar' => 'bar', 'baz' => { 'buz' => 'buz' } }] }
    expected = { :foo  => [{ :bar  => 'bar', :baz  => { :buz  => 'buz' } }] }
    assert_equal expected, hash.deep_symbolize_keys
  end

  test 'Hash#deep_symbolize_keys! replaces with deep_symbolize' do
    hash     = { 'foo' => { 'bar' => 'baz' } }
    expected = { :foo => { :bar => 'baz' } }
    hash.deep_symbolize_keys!
    assert_equal expected, hash
  end

  test 'Hash#slice returns a new hash containing the given keys' do
    hash = { :foo => 'foo', :bar => 'bar', :baz => 'baz' }
    expected = { :foo => 'foo', :bar => 'bar' }
    assert_equal expected, hash.slice(:foo, :bar)
  end

  test 'Hash#slice does not explode on a missing key' do
    hash = {}
    expected = {}
    assert_equal expected, hash.slice(:foo)
  end
end
