describe Hashr do
  describe 'initialization' do
    it 'takes nil' do
      expect { Hashr.new(nil) }.to_not raise_error
    end

    it 'does not explode on a numerical key' do
      expect { Hashr.new(1 => 2) }.to_not raise_error
    end

    it 'does not explode on a true key' do
      expect { Hashr.new(true => 'on') }.to_not raise_error
    end

    it 'raises an ArgumentError when given a string' do
      expect { Hashr.new('foo') }.to raise_error(ArgumentError)
    end

    it 'passing a block allows to define methods on the singleton class' do
      hashr = Hashr.new(count: 5) do
        def count
          @data.count
        end
      end
      expect(hashr.count).to eq(5)
    end
  end

  describe 'defined?' do
    it 'returns true when a key is defined' do
      hashr = Hashr.new(foo: 'foo')
      expect(hashr.defined?(:foo)).to eq(true)
    end

    it 'returns false when a key is not defined' do
      hashr = Hashr.new(foo: 'foo')
      expect(hashr.defined?(:bar)).to eq(false)
    end

    it 'works with a numerical key' do
      hashr = Hashr.new(1 => 'foo')
      expect(hashr.defined?(1)).to eq(true)
    end

    it 'works with a true key' do
      hashr = Hashr.new(true => 'foo')
      expect(hashr.defined?(true)).to eq(true)
    end

    it 'is indifferent about symbols/strings (string given, symbol used)' do
      hashr = Hashr.new('foo' => 'bar')
      expect(hashr.defined?(:foo)).to eq(true)
    end

    it 'is indifferent about symbols/strings (symbol given, string used)' do
      hashr = Hashr.new(foo: :bar)
      expect(hashr.defined?('foo')).to eq(true)
    end
  end

  describe 'hash access' do
    it 'is indifferent about symbols/strings (string given, symbol used)' do
      hashr = Hashr.new('foo' => { 'bar' => 'baz' })
      expect(hashr[:foo][:bar]).to eq('baz')
    end

    it 'is indifferent about symbols/strings (symbol given, string used)' do
      hashr = Hashr.new(foo: { bar: 'baz' })
      expect(hashr['foo']['bar']).to eq('baz')
    end

    it 'allows accessing keys with Hash core method names (count)' do
      expect(Hashr.new(count: 2).count).to eq(2)
    end

    it 'allows accessing keys with Hash core method names (key)' do
      expect(Hashr.new(key: 'key').key).to eq('key')
    end
  end

  describe 'hash assignment' do
    let(:hashr) { Hashr.new }

    it 'works with a string key' do
      hashr['foo'] = 'foo'
      expect(hashr.foo).to eq('foo')
    end

    it 'works with a symbol key' do
      hashr[:foo] = 'foo'
      expect(hashr.foo).to eq('foo')
    end
  end

  describe 'method access' do
    describe 'on an existing key' do
      it 'returns the value' do
        expect(Hashr.new(foo: 'foo').foo).to eq('foo')
      end

      it 'returns a nested hash' do
        expect(Hashr.new(foo: { bar: 'bar' }).foo.to_h).to eq(bar: 'bar')
      end

      it 'returns a nested array' do
        expect(Hashr.new(foo: ['bar', 'buz']).foo).to eq(['bar', 'buz'])
      end
    end

    describe 'on an existing nested key' do
      it 'returns the value' do
        expect(Hashr.new(foo: { bar: 'bar' }).foo.bar).to eq('bar')
      end

      it 'returns a nested array' do
        expect(Hashr.new(foo: { bar: ['bar', 'buz'] }).foo.bar).to eq(['bar', 'buz'])
      end
    end

    describe 'on an non-existing key' do
      it 'it returns nil' do
        expect(Hashr.new(foo: 'foo').bar).to eq(nil)
      end

      it 'it returns nil (nested key)' do
        expect(Hashr.new(foo: { bar: 'bar' }).foo.baz).to eq(nil)
      end
    end

    describe 'predicate methods' do
      it 'returns true if the key has a value' do
        expect(Hashr.new(foo: { bar: 'bar' }).foo.bar?).to eq(true)
      end

      it 'returns false if the key does not have a value' do
        expect(Hashr.new(foo: { bar: 'bar' }).foo.baz?).to eq(false)
      end
    end

    describe 'respond_to?' do
      it 'returns true for existing keys' do
        expect(Hashr.new(foo: 'bar').respond_to?(:foo)).to eq(true)
      end

      it 'returns false for missing keys' do
        expect(Hashr.new.respond_to?(:foo)).to eq(true)
      end
    end
  end

  describe 'method assignment' do
    let(:hashr) { Hashr.new }

    it 'assigns a string' do
      hashr.foo = 'foo'
      expect(hashr.foo).to eq('foo')
    end

    it 'converts a hash into a Hashr instance' do
      hashr.foo = { bar: { baz: 'baz' } }
      expect(hashr.foo.bar.baz).to eq('baz')
    end
  end

  describe 'values_at' do
    let(:hashr) { Hashr.new(foo: 'foo', bar: 'bar') }

    it 'returns values for the given keys' do
      expect(hashr.values_at(:foo, :bar)).to eq(['foo', 'bar'])
    end
  end

  describe 'is_a?' do
    let(:klass) { Class.new(Class.new(Hashr)) { default foo: 'foo' } }

    it 'returns true if the object has the given superclass' do
      expect(klass.new.is_a?(Hashr)).to eq(true)
    end

    it 'returns false if the object does not have the given superclass' do
      expect(klass.new.is_a?(Hash)).to eq(false)
    end
  end

  describe 'conversion' do
    let(:hash) { Hashr.new(foo: { 'bar' => 'baz' }).to_h }

    it 'converts the Hashr instance to a hash' do
      expect(hash.class).to eq(Hash)
    end

    it 'converts nested instances to hashes' do
      expect(hash[:foo].class).to eq(Hash)
    end

    it 'populates the hash with the symbolized keys' do
      expect(hash[:foo][:bar]).to eq('baz')
    end
  end

  describe 'defaults' do
    describe 'using a symbolized hash' do
      let(:klass) { Class.new(Hashr) { default foo: 'foo' } }

      it 'defines the default' do
        expect(klass.new['foo']).to eq('foo')
      end
    end

    describe 'using a stringified hash' do
      let(:klass) { Class.new(Hashr) { default 'foo' => 'foo' } }

      it 'defines the default' do
        expect(klass.new[:foo]).to eq('foo')
      end
    end

    describe 'with a nested hash' do
      let(:klass) { Class.new(Hashr) { default foo: { bar: { baz: 'baz' } } } }

      it 'defines the default' do
        expect(klass.new['foo'][:bar]['baz']).to eq('baz')
      end
    end

    describe 'with a nested array' do
      let(:klass) { Class.new(Hashr) { default foo: ['bar'] } }

      it 'defines the default' do
        expect(klass.new.foo.first).to eq('bar')
      end
    end

    describe 'keeps existing defaults' do
      let(:klass) { Class.new(Hashr) { default foo: 'foo'; default bar: 'bar' } }

      it 'defines the existing default' do
        expect(klass.new.foo).to eq('foo')
      end

      it 'defines the new default' do
        expect(klass.new.bar).to eq('bar')
      end
    end

    describe 'deep_merges inherited defaults' do
      let(:klass) { Class.new(Class.new(Hashr) { default foo: 'foo' }) { default bar: 'bar' } }

      it 'defines the inherited default' do
        expect(klass.new.foo).to eq('foo')
      end

      it 'defines the default' do
        expect(klass.new.bar).to eq('bar')
      end
    end
  end

  describe 'constant lookup' do
    let(:klass) { Class.new(Hashr) { def env; ENV; end } }

    it 'finds global consts' do
      expect(klass.new.env).to eq(ENV)
    end
  end
end
