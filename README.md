[![Build Status](https://secure.travis-ci.org/svenfuchs/hashr.png)](http://travis-ci.org/svenfuchs/hashr)

# Hashr

Hashr is a very simple and tiny class derived from Ruby's core Hash class which makes using nested hashes for configuration (and other purposes) easier and less repetive and error prone.

It supports the following features:

* method read and write access
* automatic predicate (boolean, i.e. `?`) methods
* easy defaults
* easy inclusion of modules into nested hashes
* automatic symbolized keys

## Usage

Directly use Hashr instances like this:

    config = Hashr.new(foo: { bar: 'bar' })

    config.foo?     # => true
    config.foo      # => { bar: 'bar' }

    config.foo.bar? # => true
    config.foo.bar  # => 'bar'

    config.foo.bar = 'bar'
    config.foo.bar # => 'bar'

    config.foo.baz = 'baz'
    config.foo.baz # => 'baz'

Hash core methods are not available but assume you mean to look up keys with
the same name:

    config = Hashr.new(count: 1, key: 'key')
    config.count # => 1
    config.key   # => 'key'

In order to check a hash stored on a certain key you can convert it to a Ruby
Hash:

    config = Hashr.new(count: 1, key: 'key')
    config.to_h.count # => 2
    config.to_h.key   # => raises ArgumentError: "wrong number of arguments (0 for 1)"

By default missing keys won't raise an exception but instead behave like Hash
access:

    config = Hashr.new
    config.foo? # => false
    config.foo  # => nil

You can make Hashr raise an `IndexError` though like this:

    Hashr.raise_missing_keys = true
    config = Hashr.new
    config.foo? # => false
    config.foo  # => raises an IndexError "Key :foo is not defined."


## Environment defaults

Hashr includes a simple module that makes it easy to overwrite configuration defaults from environment variables:

    class Config < Hashr
      extend Hashr::EnvDefaults

      self.env_namespace = 'foo'

      define boxes: { memory: '1024' }
    end

Now when an environment variable is defined then it will overwrite the default:

    ENV['FOO_BOXES_MEMORY'] = '2048'
    config = Config.new
    config.boxes.memory # => '2048'

## Other libraries

You also might want to check out OpenStruct and Hashie.

* [OpenStruct](http://ruby-doc.org/stdlib/libdoc/ostruct/rdoc/classes/OpenStruct.html) does less but comes as a Ruby standard library.
* [Hashie](https://github.com/intridea/hashie) has a bunch of support classes (like `Mash`, `Dash`, `Trash`) which all support different features that you might need.

## License

[MIT License](https://github.com/svenfuchs/hashr/blob/master/MIT-LICENSE)
