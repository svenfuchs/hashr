describe Hashr, 'method access' do
  describe 'on an existing key' do
    it 'returns the value' do
      expect(Hashr.new(foo: 'foo').foo).to eq('foo')
    end

    it 'returns a nested hash' do
      expect(Hashr.new(foo: { bar: 'bar' }).foo).to eq(bar: 'bar')
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

  describe 'with :raise_missing_keys set to false' do
    before { Hashr.raise_missing_keys = false }

    it 'it returns nil on a non-existing key' do
      expect(Hashr.new(foo: 'foo').bar).to eq(nil)
    end

    it 'it returns nil on a non-existing nested key' do
      expect(Hashr.new(foo: { bar: 'bar' }).foo.baz).to eq(nil)
    end
  end

  describe 'with :raise_missing_keys set to true' do
    before { Hashr.raise_missing_keys = true }

    it 'it raises an IndexError on a non-existing key' do
      expect { Hashr.new(foo: 'foo').bar }.to raise_error(IndexError)
    end

    it 'it raises an IndexError on a non-existing nested key' do
      expect { Hashr.new(foo: { bar: 'bar' }).foo.baz }.to raise_error(IndexError)
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
      expect(Hashr.new.respond_to?(:foo)).to eq(false)
    end
  end
end
