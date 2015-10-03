describe Hash do
  describe 'deep_symbolize_keys' do
    it 'symbolizes keys on nested hashes' do
      hash     = { 'foo' => { 'bar' => 'bar' } }
      expected = { :foo  => { :bar  => 'bar' } }
      expect(hash.deep_symbolize_keys).to eq(expected)
    end

    it 'walks arrays' do
      hash     = { 'foo' => [{ 'bar' => 'bar', 'baz' => { 'buz' => 'buz' } }] }
      expected = { :foo  => [{ :bar  => 'bar', :baz  => { :buz  => 'buz' } }] }
      expect(hash.deep_symbolize_keys).to eq(expected)
    end
  end

  describe 'deep_symbolize_keys!' do
    it 'replaces with deep_symbolize' do
      hash     = { 'foo' => { 'bar' => 'baz' } }
      expected = { :foo  => { :bar  => 'baz' } }
      hash.deep_symbolize_keys!
      expect(hash).to eq(expected)
    end
  end

  describe 'slice' do
    it 'returns a new hash containing the given keys' do
      hash     = { :foo => 'foo', :bar => 'bar', :baz => 'baz' }
      expected = { :foo => 'foo', :bar => 'bar' }
      expect(hash.slice(:foo, :bar)).to eq(expected)
    end

    it 'does not explode on a missing key' do
      expect({}.slice(:foo)).to eq({})
    end
  end
end
