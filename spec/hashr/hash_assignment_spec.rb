describe Hashr, 'hash assignment' do
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
