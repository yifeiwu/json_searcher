# Json Searcher

## Description
This project is a demonstration of a json document search engine. The documents are parsed in and the values are tokenized and used to generate an inverted index. An interactive prompt wrapper provides the command line interface for users to query the documents.

## System Dependencies and Config:
* ruby => 2.1
* awesome_print
* rspec 

## Testing
```rspec spec```

## Operation 
Run the interactive prompt via command line 
```ruby search_prompt.rb ```

## Extensions
The tokenizer can be extended to provide partial matches. Currently the simple tokenizer only provides results if the query is an exact match.

### License
MIT
