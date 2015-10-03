describe Hashr do
  shared_examples_for 'converts to a hash' do
    it 'converts the Hashr instance to a hash' do
      expect(hash.class).to eq(Hash)
    end

    it 'converts nested instances to hashes' do
      expect(hash[:foo].class).to eq(Hash)
    end

    it 'populates the hash with symbolized keys' do
      expect(hash[:foo][:bar]).to eq('baz')
    end
  end

  let(:hashr) { Hashr.new(:foo => { :bar => 'baz' }) }

  # describe 'to_h' do
  #   let(:hash) { hashr.to_h }
  #   include_examples 'converts to a hash'
  # end

  describe 'to_hash' do
    let(:hash) { hashr.to_hash }
    include_examples 'converts to a hash'
  end
end
