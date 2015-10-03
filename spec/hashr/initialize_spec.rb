describe Hashr, 'initialize' do
  it 'takes nil' do
    expect { Hashr.new(nil) }.to_not raise_error
  end

  it 'raises an ArgumentError when given a string' do
    expect { Hashr.new('foo') }.to raise_error(ArgumentError)
  end
end
