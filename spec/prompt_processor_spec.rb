require 'prompt_processor'
require 'json_searcher'

describe 'PromptProcessor' do
  DATASET = ['./spec/fixtures/users.json', './spec/fixtures/organizations.json', './spec/fixtures/tickets.json'].freeze
  DATASET_NAMES = %w(Users Organizations Tickets).freeze

  let(:js) do
    obj = JsonSearcher.new
    obj.prepare_inputs(DATASET_NAMES, *DATASET)
    obj
  end

  let(:pp) { PromptProcessor.new(js) }

  context 'when at menu level' do
    before(:each) { allow(pp).to receive(:check_state) { 0 } }

    it 'presents available commands' do
      input = 'menu'
      output = 'Available Commands'
      expect { pp.process(input) }.to output(/#{output}/).to_stdout
    end

    it 'exits' do
      input = 'end'
      expect { pp.process(input) }.to raise_exception(SystemExit)
    end

    it 'picks the correct document and rejects invalid entries' do
      inputs = %w(0 1 2 3 f)
      outputs = %w(Users Organizations Tickets Invalid unclear)

      inputs.each_with_index do |input, index|
        expect { pp.process(input) }.to output(/#{outputs[index]}/).to_stdout
      end
    end

    it 'presents the help menu' do
      input = 'help'
      output = 'Searchable Fields'
      expect { pp.process(input) }.to output(/#{output}/).to_stdout
    end

    it 'produces the correct state message' do
      input = '0'
      output = 'Available Commands'
      expect { pp.process(input) }.to output(/#{output}/).to_stdout
    end
  end

  context 'when at document level' do
    before(:each) { allow(pp).to receive(:check_state) { 1 } }

    it 'accepts field entry' do
      input = 'test_field'
      output = "\\*field: #{input}"
      expect { pp.process(input) }.to output(/#{output}/).to_stdout
    end

    it 'produces the correct state message' do
      input = 'test_field'
      output = 'Enter search field'
      expect { pp.process(input) }.to output(/#{output}/).to_stdout
    end
  end

  context 'when at field level' do
    before(:each) { allow(pp).to receive(:check_state) { 2 } }

    it 'accepts value entry' do
      input = 'test_value'
      output = "\\*value: #{input}"
      expect { pp.process(input) }.to output(/#{output}/).to_stdout
    end

    it 'produces the correct state message' do
      input = 'test_value'
      output = 'Enter search value'
      expect { pp.process(input) }.to output(/#{output}/).to_stdout
    end
  end
end
