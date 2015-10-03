describe Hashr, 'method assignment' do
  let(:hashr) { Hashr.new }

  it 'works' do
    hashr.foo = 'foo'
    expect(hashr.foo).to eq('foo')
  end
end
