describe Hashr, 'hash access' do
  it 'is indifferent about symbols/strings (string data given, symbol keys used)' do
    expect(Hashr.new('foo' => { 'bar' => 'bar' })[:foo][:bar]).to eq('bar')
  end

  it 'is indifferent about symbols/strings (symbol data given, string keys used)' do
    expect(Hashr.new(foo: { bar: 'bar' })['foo']['bar']).to eq('bar')
  end

  # it 'allows accessing keys with Hash core method names (count)' do
  #   expect(Hashr.new(count: 2).count).to eq(2)
  # end

  # it 'allows accessing keys with Hash core method names (key)' do
  #   expect(Hashr.new(key: 'key').key).to eq('key')
  # end
end
