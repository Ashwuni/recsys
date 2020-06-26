

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
    
#def show_most_similar_titles
    all_of_the_books=Book.get_ids().sort
    
    #puts books
    
    for i in 1..all_of_the_books.count #all the book ids
        max_score= -100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000#similarity(all_of_the_books[0], all_of_the_books[1])
        #puts i
        for j in 1..all_of_the_books.count#test against each book
            if all_of_the_books[i]==all_of_the_books[j]
                next j
            end
            
            similarity=similarity(all_of_the_books[i-1], all_of_the_books[j-1])

            if similarity>max_score #assuming only need to suggest one of the most similar books
                max_score=similarity
                book2_id = all_of_the_books[j-1]
            end
           
        end
        p= format_similar_message(Book.get_title(all_of_the_books[i-1]), Book.get_title(book2_id), max_score)
        puts p
    end
#end

