

require './lib/book-recsys.rb'

def format_similar_message source_book_title, most_similar_title, similarity_score
  return "People who liked #{source_book_title}," +
    " also liked #{most_similar_title}." +
    " (Score = %0.3f)" % [similarity_score]
end
    
# TODO: Insert your code here to produce the expected output
# found in expected-output/show-most-similar-titles.txt .
#
# To make sure your output is the correct format, use 
# the above method: format_similar_message
#
# To output the books in the correct order, you'll 
# need process them in order of their book_ids (ascending).
    

