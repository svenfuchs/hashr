describe Hashr::Env do
  let(:klass) do
    Class.new(Hashr) do
      extend Hashr::Env

      self.env_namespace = 'hashr'

      define string: 'string',
             hash:   { key: 'value' },
             array:  ['foo', 'bar'],
             bool:   false,
             int:    4,
             float:  11.1
    end
  end

  after do
    ENV.keys.each { |key| ENV.delete(key) if key.start_with?('HASHR_') }
  end

  it 'defaults to an env var' do
    ENV['HASHR_STRING'] = 'env string'
    expect(klass.new.string).to eq('env string')
  end

  it 'defaults to a nested env var' do
    ENV['HASHR_HASH_KEY'] = 'env value'
    expect(klass.new.hash.key).to eq('env value')
  end

  describe 'type casts based on the default' do
    describe 'to boolean' do
      it 'true given' do
        ENV['HASHR_BOOL'] = 'true'
        expect(klass.new.bool).to eq(true)
      end

      it 'false given' do
        ENV['HASHR_BOOL'] = 'false'
        expect(klass.new.bool).to eq(false)
      end

      it 'empty string given' do
        ENV['HASHR_BOOL'] = ''
        expect(klass.new.bool).to eq(false)
      end
    end

    describe 'to an array' do
      it 'splits a comma-separated string' do
        ENV['HASHR_ARRAY'] = 'env foo,env bar'
        expect(klass.new.array).to eq(['env foo', 'env bar'])
      end

      it 'returns an empty array for an empty string' do
        ENV['HASHR_ARRAY'] = ''
        expect(klass.new.array).to eq([])
      end
    end

    describe 'to an int' do
      it 'int given' do
        ENV['HASHR_INT'] = '1'
        expect(klass.new.int).to eq(1)
      end

      it 'errors for an empty string' do
        ENV['HASHR_INT'] = ''
        expect { klass.new.int }.to raise_error(ArgumentError)
      end

      it 'errors for a non-int' do
        ENV['HASHR_INT'] = 'a'
        expect { klass.new.int }.to raise_error(ArgumentError)
      end
    end

    describe 'to a float' do
      it 'float given' do
        ENV['HASHR_FLOAT'] = '2.3'
        expect(klass.new.float).to eq(2.3)
      end

      it 'int given' do
        ENV['HASHR_FLOAT'] = '4'
        expect(klass.new.float).to eq(4.0)
      end

      it 'errors for an empty string' do
        ENV['HASHR_FLOAT'] = ''
        expect { klass.new.float }.to raise_error(ArgumentError)
      end

      it 'errors for a non-float' do
        ENV['HASHR_FLOAT'] = 'a'
        expect { klass.new.float }.to raise_error(ArgumentError)
      end
    end
  end

  it 'data takes precedence over an env var' do
    ENV['HASHR_STRING'] = 'env string'
    expect(klass.new(string: 'data string').string).to eq('data string')
  end
end
