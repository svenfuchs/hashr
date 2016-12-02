require 'hashr/delegate/hash'

describe Hashr::Delegate::Hash do
  context 'included in Hashr class' do

    let(:klass) { Class.new(Hashr) { include Hashr::Delegate::Hash } }

    it 'delegates key?' do
      hashr = klass.new(foo: 'foo')
      expect(hashr.key?(:foo)).to eq(true)
    end

    it 'delegates select' do
      hashr = klass.new(foo: 'foo', bar: 'bar')
      expect(hashr.select { |key, value| key == :bar }).to eq(bar: 'bar')
    end

    it 'delegates delete' do
      hashr = klass.new(foo: 'foo', bar: 'bar')
      hashr.delete(:foo)
      expect(hashr.to_h).to eq(bar: 'bar')
    end

    it 'delegates fetch' do
      hashr = klass.new(foo: 'foo')
      expect(hashr.fetch(:foo)).to eq('foo')
      expect(hashr.fetch(:bar, 'bar')).to eq('bar')
    end
  end
end
