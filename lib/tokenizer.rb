# takes an array of json and creates a dictionary set for each term consisting of the values from each entry

module Tokenizer
  # creates a inverted index using the unparsed string value
  def self.simple_parse(entries)
    dictionary_set = {}
    entries.each_with_index do |entry, entry_index|
      entry.each do |field, value|
        dictionary_set[field.to_s] ||= {} # initialize the field dictionary
        (dictionary_set[field.to_s][value.to_s] ||= []) << entry_index
      end
    end
    dictionary_set
  end
end
