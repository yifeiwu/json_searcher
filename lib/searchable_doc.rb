# create a doc store that is searchable

require 'tokenizer'
require 'response'

class SearchableDoc
  def initialize(doc)
    @doc_contents = doc
    @iindex = nil
  end

  def build_index
    response = Response.new
    begin
      @iindex = generate_index(@doc_contents)
    rescue => e
      response.error = "Problem creating index. #{e}"
    end
    response.error
  end

  def list_fields
    return [] if @iindex.nil?
    @iindex.keys
  end

  def search(field, value)
    return [] if @iindex.nil?
    search_results = @iindex.dig(field.to_s, value.to_s)
    return [] if search_results.nil?
    @doc_contents.values_at(*search_results)
  end

  private

  def generate_index(input, token_strategy = 'simple_parse')
    m = Tokenizer.method(token_strategy)
    m.call(input)
  end
end
