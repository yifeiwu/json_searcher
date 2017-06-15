# process prompt commands

require 'awesome_print'

class PromptProcessor
  MENU_INSTRUCTIONS = "Available Commands\n '0' to search Users\n '1' to search Organizations\n '2' to search Tickets.\n" \
                       " 'end' to quit.\n 'menu' to go back to main menu\n 'help' to get available fields".freeze
  SEARCH_FIELD_INSTRUCTIONS = 'Enter search field'.freeze
  SEARCH_VALUE_INSTRUCTIONS = 'Enter search value'.freeze
  RESET_INSTRUCTIONS = "Enter 'menu' to go start over".freeze
  STATES = %w(menu document_picked field_picked value_picked).freeze
  STATE_MSG = [MENU_INSTRUCTIONS, SEARCH_FIELD_INSTRUCTIONS, SEARCH_VALUE_INSTRUCTIONS, RESET_INSTRUCTIONS].freeze
  DOC_LIST = %w(Users Organizations Tickets).freeze

  def initialize(js)
    @js = js
    @document = nil
    @field = nil
    @value = nil
  end

  def process(input)
    display_out(state_dependent_parse(input))
  end

  private

  def state_dependent_parse(input)
    current_state = STATES[check_state]
    m = method("#{current_state}_parse")
    generate_parse_output(m, input)
  end

  def menu_parse(input)
    case input
    when 'menu'
      clear_state
      ''
    when 'help'
      generate_help
    when 'end'
      exit
    when /([0-9]+)/
      output = generate_doc_picked_status(Regexp.last_match(1))
    else
      output = 'Input unclear, retry?'
    end
  end

  def document_picked_parse(input)
    case input
    when 'menu'
      clear_state
    when 'end'
      exit
    when /(.*)/
      generate_field_status(Regexp.last_match(1).to_s)
    end
  end

  def field_picked_parse(input)
    case input
    when 'menu'
      clear_state
    when 'end'
      exit
    when /(.*)/
      generate_search_results(Regexp.last_match(1).to_s)
    end
  end

  def display_out(input)
    puts input
  end

  def generate_parse_output(m, input)
    output = ''
    output << m.call(input)
    output << "\n"
    output << STATE_MSG[check_state]
    output
  end

  def generate_help
    output = ''
    output << 'Searchable Fields'
    doc_fields = @js.list_fields
    doc_fields.each do |doc|
      output << doc.keys.ai(index: false)
      output << doc.values.first.ai(index: false)
    end
    output
  end

  def generate_doc_picked_status(input)
    @document = DOC_LIST[input.to_i]
    if @document
      "Searching:\n *#{@document}"
    else
      'Invalid selection'
    end
  end

  def generate_field_status(input)
    @field = input
    "Searching:\n *document: #{@document}\n *field: #{@field}"
  end

  def generate_search_results(input)
    output = ''
    @value = input
    output << "Search Results\n *document: #{@document}\n *field: #{@field}\n *value: #{@value}\n\n"
    result = @js.search(@document, @field, @value)
    output << if result.empty?
                'No Results'
              else
                result.ai(index: false)
              end
    clear_state
    output
  end

  def clear_state
    @document = nil
    @field = nil
    @value = nil
end

  def check_state
    return 3 unless [@value, @field, @document].any?(&:nil?)
    return 2 unless [@field, @document].any?(&:nil?)
    return 1 unless @document.nil?
    0
  end
end
