describe Hashr, 'defaults' do
  shared_examples_for 'defaults' do |method|
    describe 'using a symbolized hash' do
      let(:klass) { Class.new(Hashr) { send method, foo: 'foo' } }

      it 'defines the default' do
        expect(klass.new.foo).to eq('foo')
      end
    end

    describe 'using a stringified hash' do
      let(:klass) { Class.new(Hashr) { send method, 'foo' => 'foo' } }

      it 'defines the default' do
        expect(klass.new.foo).to eq('foo')
      end
    end

    describe 'with a nested hash' do
      let(:klass) { Class.new(Hashr) { send method, foo: { bar: { baz: 'baz' } } } }

      it 'defines the default' do
        expect(klass.new.foo.bar.baz).to eq('baz')
      end
    end

    describe 'with a nested array' do
      let(:klass) { Class.new(Hashr) { send method, foo: ['bar'] } }

      it 'defines the default' do
        expect(klass.new.foo.first).to eq('bar')
      end
    end
  end

  # describe 'definition using default' do
  #   include_examples 'defaults', :default
  # end

  describe 'definition using define (deprecated)' do
    include_examples 'defaults', :define
  end
end
