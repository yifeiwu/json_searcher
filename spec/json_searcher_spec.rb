require 'json_searcher'

describe 'JsonSearcher' do
  let(:good_file_set) { ['spec/fixtures/users.json', 'spec/fixtures/organizations.json', 'spec/fixtures/tickets.json'] }
  let(:bad_file_set) { ['spec/bad_users.json', 'spec/organizations.json', 'spec/tickets.json'] }
  let(:dataset_names) { %w(Users Organizations Tickets).freeze }

  let(:searcher) { JsonSearcher.new }

  it 'reads in the files' do
    response = searcher.prepare_inputs(dataset_names, *good_file_set)
    expect(response.error).to be_nil
  end

  it 'reads in and throws error when files are bad' do
    response = searcher.prepare_inputs(dataset_names, *bad_file_set)
    expect(response.error).to_not be nil
  end

  it 'will list all the fields' do
    searcher.prepare_inputs(dataset_names, *good_file_set)
    response = searcher.list_fields
    expect(response.first[:Users]).to include('url', 'external_id', 'name', 'alias', 'created_at', 'active')
    expect(response.first[:Users].size).to eq(19)
  end

  context 'when performing searches on documents' do
    it 'filters correctly' do
      searcher.prepare_inputs(dataset_names, *good_file_set)

      response = searcher.search('Users', 'active', 'true')
      expect(response.first).to include('active' => true)
      expect(response.first).to_not include('active' => false)
      expect(response.size).to eq(39)
    end
    it 'returns empty array if not found' do
      searcher.prepare_inputs(dataset_names, *good_file_set)

      response = searcher.search('Users', 'schma-active', 'true')
      expect(response).to eq([])

      response = searcher.search('Users', 'active', 'arrgh')
      expect(response).to eq([])

      response = searcher.search('blargh', 'active', 'arrgh')
      expect(response).to eq([])
    end
  end
end
