require 'tokenizer'

describe 'Tokenizer' do
  let(:dataset) { [{ id: 1, name: 'blue' }, { id: 2, name: 'red' }] }
  let(:iindex) { { 'id' => { '1' => [0], '2' => [1] }, 'name' => { 'blue' => [0], 'red' => [1] } } }

  it 'creates an inverted index' do
    response = Tokenizer.simple_parse(dataset)
    expect(response).to eq(iindex)
  end
end
