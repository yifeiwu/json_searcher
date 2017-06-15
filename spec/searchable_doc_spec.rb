require 'searchable_doc'

describe 'SearchableDoc' do
  let(:good_dataset) { [{ id: 1, name: 'blue' }, { id: 2, name: 'red' }, { id: 3, name: 'blue' }] }
  let(:bad_dataset) { [{ id: 1, name: 'blue' }, 'bah', { id: 2, name: 'red' }] }

  let(:iindex) { { 'id' => { '1' => 0, '2' => 1, '3' => 2 }, 'name' => { 'blue' => [0, 2], 'red' => 1 } } }

  it 'creates a searchable doc index' do
    sd = SearchableDoc.new(good_dataset)
    errors = sd.build_index
    expect(errors).to be_nil
  end

  it 'raises an error if the dataset is bad' do
    sd = SearchableDoc.new(bad_dataset)
    errors = sd.build_index
    expect(errors).to be_truthy
  end

  it 'is searchable' do
    sd = SearchableDoc.new(good_dataset)
    sd.build_index
    result = sd.search('name', 'red')
    expect(result.first).to match(id: 2, name: 'red')
  end

  it 'returns multiple results' do
    sd = SearchableDoc.new(good_dataset)
    sd.build_index
    result = sd.search('name', 'blue')
    expect(result.size).to eq(2)
  end

  it 'lists all the fields' do
    sd = SearchableDoc.new(good_dataset)
    sd.build_index
    result = sd.list_fields
    expect(result).to match(%w(id name))
  end
end
