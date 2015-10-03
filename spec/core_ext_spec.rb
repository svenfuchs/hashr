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
end
