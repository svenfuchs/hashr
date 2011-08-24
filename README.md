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

    config = Hashr.new('foo' => { 'bar' => 'bar' })

    config.foo?     # => true
    config.foo      # => { :bar => 'bar' }

    config.foo.bar? # => true
    config.foo.bar  # => 'bar'

    config.foo.bar = 'bar!'
    config.foo.bar # => 'bar!'

    config.foo.baz = 'baz'
    config.foo.baz # => 'baz'

Be aware that by default missing keys won't raise an exception but instead behave like Hash access:

    config = Hashr.new
    config.foo? # => false
    config.foo  # => nil

You can make Hashr raise an `IndexError` though like this:

    Hashr.raise_missing_keys = true
    config = Hashr.new
    config.foo? # => false
    config.foo  # => raises an IndexError "Key :foo is not defined."

You can also anonymously overwrite core Hash methods like this:

    config = Hashr.new(:count => 3) do
      def count
        self[:count]
      end
    end
    config.count # => 3

And you can anonymously provide defaults like this:

    data     = { :foo => 'foo' }
    defaults = { :bar => 'bar' }
    config   = Hashr.new(data, defaults)
    config.foo # => 'foo'
    config.bar # => 'bar'

But you can obvioulsy also derive a custom class to define defaults and overwrite core Hash methods like this:

    class Config < Hashr
      define :foo => { :bar => 'bar' }

      def count
        self[:count]
      end
    end

    config = Config.new
    config.foo.bar # => 'bar'

Include modules to nested hashes like this:

    class Config < Hashr
      module Boxes
        def count
          self[:count] # overwrites a Hash method to return the Hash's content here
        end

        def names
          @names ||= (1..count).map { |num| "box-#{num}" }
        end
      end

      define :boxes => { :count => 3, :_include => Boxes }
    end

    config = Config.new
    config.boxes       # => { :count => 3 }
    config.boxes.count # => 3
    config.boxes.names # => ["box-1", "box-2", "box-3"]

As overwriting Hash methods for method access to keys is a common pattern there's a short cut to it:

    class Config < Hashr
      define :_access => [:count, :key]
    end

    config = Config.new(:count => 3, :key => 'key')
    config.count # => 3
    config.key   # => 'key'

Both `:_include` and `:_access` can be defined as defaults, i.e. so that they will be used on all nested hashes:

    class Config < Hashr
      default :_access => :key
    end

    config = Config.new(:key => 'key', :foo => { :key => 'foo.key' })
    config.key     # => 'key'
    config.foo.key # => 'foo.key'

## Environment defaults

Hashr includes a simple module that makes it easy to overwrite configuration defaults from environment variables:

    class Config < Hashr
      extend Hashr::EnvDefaults

      self.env_namespace = 'foo'

      define :boxes => { :memory => '1024' }
    end

Now when an environment variable is defined then it will overwrite the default:

    ENV['FOO_BOXES_MEMORY'] = '2048'
    config = Config.new
    config.boxes.memory # => '2048'

## Running the tests

You can run the tests as follows:

    # going through bundler
    bundle exec rake

    # using just ruby
    ruby -rubygems -Ilib:test test/hashr_test.rb

## Other libraries

You also might want to check out OpenStruct and Hashie.

* [OpenStruct](http://ruby-doc.org/stdlib/libdoc/ostruct/rdoc/classes/OpenStruct.html) does less but comes as a Ruby standard library.
* [Hashie](https://github.com/intridea/hashie) has a bunch of support classes (like `Mash`, `Dash`, `Trash`) which all support different features that you might need.

## License

[MIT License](https://github.com/svenfuchs/hashr/blob/master/MIT-LICENSE)
