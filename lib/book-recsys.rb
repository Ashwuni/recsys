
require './lib/models.rb' # Give us access to the database, see file for info

def num_non_zero_ratings book_id  
    book_id_array = Rating.book_ratings_array(book_id)
    
    num_non_zero_ratings = 0
    
    for i in 1..(book_id_array.count)
        if book_id_array[i-1] !=0
            num_non_zero_ratings+=1
        end
    end
    return num_non_zero_ratings
end


def average_book_rating book_id    
    book_id_array = Rating.book_ratings_array(book_id)
    num_non_zero_ratings = num_non_zero_ratings(book_id)
    sum = 0.0
    
    for i in 1..(book_id_array.count)
        book_score=book_id_array[i-1]
        sum+=book_score
    end
    if num_non_zero_ratings == 0
        return 0.0
    end 
    average_book_rating = sum/(num_non_zero_ratings*1.0)
    return average_book_rating
end

# Given two book_id's, compute and return the cosine similarity
# between the two books.  If a book has zero non-zero
# ratings, the similarity is zero.  
def similarity book_a, book_b
                
    
    book_a_score_array=Rating.book_ratings_array(book_a) ####HASHMAP
    book_b_score_array=Rating.book_ratings_array(book_b) ####HASHMAP
    
    book_a_score_sum = book_a_score_array.sum{|r| r**2}
    book_b_score_sum =book_b_score_array.sum{|r| r**2}
    
    denominator=(Math.sqrt(book_a_score_sum)*Math.sqrt(book_b_score_sum))

    user_id_array = User.get_ids()
    
    if num_non_zero_ratings(book_a) == 0||num_non_zero_ratings(book_b) == 0||denominator==0
        similarity = 0.0
    else
        numerator=0.0
        #book_a_score_sum=0.0
        #book_b_score_sum=0.0
        #for i in 1...(User.get_ids().count)
        user_id_array.each do |users|
            multiplication = (book_a_score_array[users] * book_b_score_array[users])
        
            #user_id_array=User.get_ids() ####HASHMAP
            
           # book_a_score_array=Rating.book_ratings_array(book_a) ####HASHMAP
           # book_b_score_array=Rating.book_ratings_array(book_b) ####HASHMAP
            
           # user = user_id_array[i-1]
           # book_a_score=book_a_score_array.select{|book_score| user_id = user}
            #book_b_score=book_b_score_array.select{|book_score| user_id = user}
            
            #book_a_score=book_a_score_array[user_id_array[i-1]]
            #book_b_score=book_b_score_array[user_id_array[i-1]]
            
            #multiplication = (book_a_score.to_i * book_b_score.to_i)
           # multiplication_a = (book_a_score.to_i**2)
           # multiplication_b = (book_b_score.to_i**2)
            
            numerator+=multiplication
           # book_a_score_sum+=multiplication_a
            #book_b_score_sum+=multiplication_b
        end
        #denominator=(Math.sqrt(book_a_score_sum)*Math.sqrt(book_b_score_sum))
        #if denominator==0.0
         #   similarity=0.0
       # else
        similarity=numerator/(denominator*1.0)
        #end
    end
    
    return similarity
end

            
            #book_a_score=user_id_array.select{|book_ratings| user_id = User.get_ids[i]}
            #book_b_score=book_b_score_array.select{|book_ratings| user_id = User.get_ids[i]}
            
            #book_a_score=book_a_score_array.select{|book_ratings| user_id = User.get_ids[i]}
            #book_b_score=book_b_score_array.select{|book_ratings| user_id = User.get_ids[i]}

