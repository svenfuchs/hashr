require 'test_helper'

class HashrTest < Test::Unit::TestCase
  def teardown
    Hashr.raise_missing_keys = false
  end

  test 'initialize takes nil' do
    assert_nothing_raised { Hashr.new(nil) }
  end

  test 'method access on an existing key returns the value' do
    assert_equal 'foo', Hashr.new(:foo => 'foo').foo
  end

  test 'method access on a non-existing key returns nil when raise_missing_keys is false' do
    Hashr.raise_missing_keys = false
    assert_nil Hashr.new(:foo => 'foo').bar
  end

  test 'method access on a non-existing key raises an IndexError when raise_missing_keys is true' do
    Hashr.raise_missing_keys = true
    assert_raises(IndexError) { Hashr.new(:foo => 'foo').bar }
  end

  test 'method access on an existing nested key returns the value' do
    assert_equal 'bar', Hashr.new(:foo => { :bar => 'bar' }).foo.bar
  end

  test 'method access on a non-existing nested key returns nil when raise_missing_keys is false' do
    Hashr.raise_missing_keys = false
    assert_nil Hashr.new(:foo => { :bar => 'bar' }).foo.baz
  end

  test 'method access on a non-existing nested key raises an IndexError when raise_missing_keys is true' do
    Hashr.raise_missing_keys = true
    assert_raises(IndexError) { Hashr.new(:foo => { :bar => 'bar' }).foo.baz }
  end

  test 'method access with a question mark returns true if the key has a value' do
    assert_equal true, Hashr.new(:foo => { :bar => 'bar' }).foo.bar?
  end

  test 'method access with a question mark returns false if the key does not have a value' do
    assert_equal false, Hashr.new(:foo => { :bar => 'bar' }).foo.baz?
  end

  test 'hash access is indifferent about symbols/strings (string data given, symbol keys used)' do
    assert_equal 'bar', Hashr.new('foo' => { 'bar' => 'bar' })[:foo][:bar]
  end

  test 'hash access is indifferent about symbols/strings (symbol data given, string keys used)' do
    assert_equal 'bar', Hashr.new(:foo => { :bar => 'bar' })['foo']['bar']
  end

  test 'mixing symbol and string keys in defaults and data' do
    Symbolized  = Class.new(Hashr) { define :foo => 'foo' }
    Stringified = Class.new(Hashr) { define 'foo' => 'foo' }
    NoDefault   = Class.new(Hashr)

    assert_equal 'foo', Symbolized.new.foo
    assert_equal 'foo', Stringified.new.foo
    assert_nil NoDefault.new.foo

    assert_equal 'foo', Symbolized.new(:foo => 'foo').foo
    assert_equal 'foo', Stringified.new(:foo => 'foo').foo
    assert_equal 'foo', NoDefault.new(:foo => 'foo').foo

    assert_equal 'foo', Symbolized.new('foo' => 'foo').foo
    assert_equal 'foo', Stringified.new('foo' => 'foo').foo
    assert_equal 'foo', NoDefault.new('foo' => 'foo').foo
  end

  test 'method assignment works' do
    hashr = Hashr.new
    hashr.foo = 'foo'
    assert_equal 'foo', hashr.foo
  end

  test 'method using a string key works' do
    hashr = Hashr.new
    hashr['foo'] = 'foo'
    assert_equal 'foo', hashr.foo
  end

  test 'using a symbol key works' do
    hashr = Hashr.new
    hashr[:foo] = 'foo'
    assert_equal 'foo', hashr.foo
  end

  test 'defining defaults' do
    klass = Class.new(Hashr) do
      define :foo => 'foo', :bar => { :baz => 'baz' }
    end
    assert_equal 'foo', klass.new.foo
    assert_equal 'baz', klass.new.bar.baz
  end

  test 'defining different defaults on different classes ' do
    foo = Class.new(Hashr) { define :foo => 'foo' }
    bar = Class.new(Hashr) { define :bar => 'bar' }

    assert_equal 'foo', foo.definition[:foo]
    assert_equal 'bar', bar.definition[:bar]
  end

  test 'defining different env_namespaces on different classes ' do
    foo = Class.new(Hashr) {extend Hashr::EnvDefaults; self.env_namespace = 'foo' }
    bar = Class.new(Hashr) {extend Hashr::EnvDefaults; self.env_namespace = 'bar' }

    assert_equal ['FOO'], foo.env_namespace
    assert_equal ['BAR'], bar.env_namespace
  end

  test 'defaults to env vars' do
    klass = Class.new(Hashr) do
      extend Hashr::EnvDefaults
      self.env_namespace = 'hashr'
      define :foo => 'foo', :bar => { :baz => 'baz' }
    end

    ENV['HASHR_FOO'] = 'env foo'
    ENV['HASHR_BAR_BAZ'] = 'env bar baz'

    hashr = klass.new
    assert_equal 'env foo', hashr.foo
    assert_equal 'env bar baz', hashr.bar.baz

    # ENV.delete('HASHR_FOO')
    # ENV.delete('HASHR_BAR_BAZ')

    # hashr = klass.new
    # assert_equal 'foo', hashr.foo
    # assert_equal 'bar baz', hashr.bar.baz
  end

  test 'a key :_include includes the given modules' do
    klass = Class.new(Hashr) do
      define :foo => { :_include => Module.new { def helper; 'helper'; end } }
    end
    hashr = klass.new(:foo => { 'helper' => 'foo' })
    assert_equal 'helper', klass.new(:foo => { 'helper' => 'foo' }).foo.helper
  end

  test 'a key :_include includes the given modules (using defaults)' do
    klass = Class.new(Hashr) do
      define :foo => { :_include => Module.new { def helper; 'helper'; end } }
    end
    assert_equal 'helper', klass.new.foo.helper
  end

  test 'a key :_access includes an anonymous module with accessors' do
    klass = Class.new(Hashr) do
      define :foo => { :_access => [:key] }
    end

    assert_equal 'key', klass.new(:foo => { :key => 'key' }).foo.key
  end

  test 'defining defaults always also makes sure an accessor is used' do
    klass = Class.new(Hashr) do
      define :foo => { :default => 'default' }
    end

    assert_equal 'default', klass.new().foo.default
  end

  test 'all: allows to define :_include modules which will be included into all nested hashes' do
    klass = Class.new(Hashr) do
      default :_include => Module.new { def helper; 'helper'; end }
    end
    assert_equal 'helper', klass.new.helper
    assert_equal 'helper', klass.new(:foo => { :bar => {} }).foo.bar.helper
  end

  test 'all: allows to define :_access which will include an anonymous module with accessors into all nested hashes' do
    klass = Class.new(Hashr) do
      default :_access => :key
    end
    assert_equal 'key', klass.new(:key => 'key').key
    assert_equal 'key', klass.new(:foo => { :bar => { :key => 'key' } }).foo.bar.key
  end

  test 'anonymously overwriting core Hash methods' do
    hashr = Hashr.new(:count => 5) do
      def count
        self[:count]
      end
    end
    assert_equal 5, hashr.count
  end

  test 'to_hash converts the Hashr instance and all of its children to Hashes' do
    hash = Hashr.new(:foo => { :bar => { :baz => 'baz' } }).to_hash

    assert hash.instance_of?(Hash)
    assert hash[:foo].instance_of?(Hash)
    assert hash[:foo][:bar].instance_of?(Hash)
  end

  test 'set sets a dot separated path to nested hashes' do
    hashr = Hashr.new(:foo => { :bar => 'bar' })
    hashr.set('foo.baz', 'baz')
    assert_equal 'baz', hashr.foo.baz
  end
end

