[![Build Status](https://secure.travis-ci.org/svenfuchs/hashr.png)](http://travis-ci.org/svenfuchs/hashr)

# Hashr

Hashr is a very simple and tiny class which makes using nested hashes for
configuration (and other purposes) easier.

It supports the following features:

* method read and write access
* automatic predicate (boolean, i.e. `?`) methods
* easy defaults
* indifferent (strings vs symbols) keys

## Usage

Directly use Hashr instances like this:

```ruby
config = Hashr.new(foo: { bar: 'bar' })

config.foo?     # => true
config.foo      # => { bar: 'bar' }

config.foo.bar? # => true
config.foo.bar  # => 'bar'

config.foo.bar = 'bar'
config.foo.bar # => 'bar'

config.foo.baz = 'baz'
config.foo.baz # => 'baz'
```

Hash core methods are not available but assume you mean to look up keys with
the same name:

```ruby
config = Hashr.new(count: 1, key: 'key')
config.count # => 1
config.key   # => 'key'
```

In order to check a hash stored on a certain key you can convert it to a Ruby
Hash:

```ruby
config = Hashr.new(count: 1, key: 'key')
config.to_h.count # => 2
config.to_h.key   # => raises ArgumentError: "wrong number of arguments (0 for 1)"
```

Missing keys won't raise an exception but instead behave like Hash access:

```ruby
config = Hashr.new
config.foo? # => false
config.foo  # => nil
```

## Defaults

Defaults can be defined per class:

```ruby
class Config < Hashr
  default boxes: { memory: '1024' }
end

config = Config.new
config.boxes.memory # => 1024
```

Or passed to the instance:

```ruby
data = {}
defaults = { boxes: { memory: '1024' } }

config = Hashr.new(data, defaults)
config.boxes.memory # => 1024
```

## Environment defaults

Hashr includes a simple module that makes it easy to overwrite configuration
defaults from environment variables:

```ruby
class Config < Hashr
  extend Hashr::EnvDefaults

  self.env_namespace = 'foo'

  default boxes: { memory: '1024' }
end
```

Now when an environment variable is defined then it will overwrite the default:

```ruby
ENV['FOO_BOXES_MEMORY'] = '2048'
config = Config.new
config.boxes.memory # => '2048'
```

## Other libraries

You also might want to check out OpenStruct and Hashie.

* [OpenStruct](http://ruby-doc.org/stdlib/libdoc/ostruct/rdoc/classes/OpenStruct.html) does less but comes as a Ruby standard library.
* [Hashie](https://github.com/intridea/hashie) has a bunch of support classes (like `Mash`, `Dash`, `Trash`) which all support different features that you might need.

## License

[MIT License](https://github.com/svenfuchs/hashr/blob/master/MIT-LICENSE)
