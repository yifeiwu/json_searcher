#this is the main program that produces the interactive prompt

$LOAD_PATH.unshift(File.dirname(__FILE__), 'lib')
require 'json_searcher'
require 'prompt_processor'

DATASET = ['./spec/fixtures/users.json', './spec/fixtures/organizations.json', './spec/fixtures/tickets.json'].freeze
DATASET_NAMES = %w(Users Organizations Tickets).freeze
PROMPT = 'Welcome to Zdesk Search!'.freeze
LOAD_SUCCESS = 'Search documents successfully loaded'.freeze
MENU_INSTRUCTIONS = "Available Commands\n '0' to search Users\n '1' to search Organizations\n '2' to search Tickets.\n" \
                       " 'end' to quit.\n 'menu' to go back to main menu\n 'help' to get available terms".freeze

puts PROMPT
js = JsonSearcher.new

response = js.prepare_inputs(DATASET_NAMES, *DATASET)
unless response.success?
  puts response.error
  exit
end
puts LOAD_SUCCESS
puts MENU_INSTRUCTIONS

pp = PromptProcessor.new(js)

while c = gets.chomp

  pp.process(c)

end
