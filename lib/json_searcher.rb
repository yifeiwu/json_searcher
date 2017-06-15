#Parses and creates Searchable Docs

require 'json'
require 'searchable_doc'
require 'response'

class JsonSearcher
  def initialize
    @searchable_documents = {}
  end

  def prepare_inputs(names, *files)
    response = Response.new

    read_docs = read_files(*files)
    response.collate_errors(read_docs)

    return response unless read_docs.success?
    read_docs.content.each_with_index do |doc, doc_index|
      processed_doc = process_document(doc)
      response.collate_errors(processed_doc)
      return response unless processed_doc.success?
      @searchable_documents["#{names[doc_index]}"] = processed_doc.content
    end
    response
  end

  def list_documents
    @searchable_documents.keys
  end

  def list_fields
    output = []
    @searchable_documents.each do |k,v|
      output << {"#{k}": v.list_fields}
    end
    output
  end


  def search(document, field, value)
    @searchable_documents["#{document}"]&.search(field, value) || []
  end


private
  def read_file(file)
    response = Response.new
    begin
      response.content = JSON.parse(File.read(file))
    rescue => e
      response.error = "Problem reading #{file}. Make sure it exists and is a proper JSON!"
    end
    response
  end

  def read_files(*files)
    response = Response.new
    files.each do |file|
      result = read_file(file)
      (response.content ||= []) << result.content
      response.collate_errors(result, 'Error in file read step! ')
    end
    response
  end

  def process_document(document)
    response = Response.new
    sd = SearchableDoc.new(document)
    response.error = sd.build_index
    response.content = sd

    response
  end

end
