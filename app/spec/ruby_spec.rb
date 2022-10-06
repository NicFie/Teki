describe Array do
  before do
    @strings = %w[foo bar]
  end

  it 'returns a new array by mapping the elements through the block' do
    expect(@strings.map(&:upcase)).to eql(%w[FOO BAR])
  end
end
