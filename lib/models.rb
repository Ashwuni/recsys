
require 'pg'
require 'active_record'
require 'composite_primary_keys'

ActiveRecord::Base.establish_connection(
	    :adapter => "postgresql",
	    :username => "codio",
	  # :password => "codio",
        :database => "bookratings")

# Book (books table in database)
#
# id : integer, primary key
# title: string
# author: string
#
class Book < ActiveRecord::Base
    
    # given a book id, returns the book's title
    # Example:
    #   Book.get_title(1)
    #
    def self.get_title book_id
        Book.find(book_id).title
    end

    # given a book id, returns the book's author
    # Example:
    #   Book.get_author(1)
    #
    def self.get_author book_id
        Book.find(book_id).author
    end
    
    # returns an array of all book ids in db
    def self.get_ids 
        ids = [] 
        Book.find_each do |b|
            ids << b.id
        end
        return ids
    end
    
end

# User (users table in database)
#
# id : integer, primary key
# name: string
#
class User < ActiveRecord::Base

    # given a user id, returns the user's name
    # Example:
    #   User.get_name(1)
    def self.get_name user_id
        User.find(user_id).name
    end   

    # returns an array of all use ids in db
    def self.get_ids 
        ids = [] 
        User.find_each do |u|
            ids << u.id
        end
        return ids
    end
    
end

# Rating (ratings table in database)
#
# user_id: integer, FK users.id
# book_id: integer, FK books.id
# rating: integer (-5 to +5)
# primary key: user_id, book_id
#
class Rating < ActiveRecord::Base
   self.primary_keys = :user_id, :book_id

   # book_ratings gives us all the ratings for a book.
   # The hash maps from user_id to to that user's rating for this book.
   # If no such book_id exists, an empty hash is returned.
   # Example usage:
   #   user2rating = Rating.book_ratings 5
   def self.book_ratings book_id
      user2rating = Hash.new 
      Rating.where( book_id: book_id ).each do |r|
          user2rating[r.user_id] = r.rating
      end
      return user2rating
   end  
    
   # user_ratings returns a hash that shows a user's ratings.
   # The hash maps book_id to the user's rating.
   # If no such user_id exists, an empty hash is returned.
   # Example usage:
   #   book2rating = Rating.user_ratings 5
   def self.user_ratings user_id
      book2rating = Hash.new 
      Rating.where( user_id: user_id ).each do |r|
          book2rating[r.book_id] = r.rating
      end
      return book2rating
   end

   # book_ratings_array returns gives us all the ratings for a book,
   # and include ratings of zero for a user that did not read or rate 
   # the book.  Also, if no such user exists (for example, user_id=0
   # doesn't exist in the database), that non-user has a rating of zero.
   # If book_id does not exist in the db, an empty array is returned.
   # The array is sized to hold a value from 0 to max user_id in the
   # users table at the time it is created.
   #  
   # results = Rating.book_ratings_array(10) # gets ratings for book_id=10
   # results[5] # is user_id=5 rating of book_id = 10
   def self.book_ratings_array book_id
      max_user_id = User.maximum("id")
      user2rating = Array.new(max_user_id + 1)
      Rating.where( book_id: book_id ).each do |r|
          user2rating[r.user_id] = r.rating
      end
      user2rating.map { |x| x ||= 0 }
   end  
    
   # user_ratings_array returns an array that shows all user's ratings
   # and a user has a zero if not read or rated the book.  Note: an
   # invalid book_id, i.e. a book that is not in the books table,
   # will be given a rating of zero.  For example, book_id = 0, cannot
   # exist.
   # If user_id does not exist in the db, an empty array is returned.
   # The array is sized to hold a value from 0 to max book_id in the
   # books table at the time it is created.
   #   
   # results = Rating.user_ratings_array(10) # gets ratings for user_id=10
   # results[5] # is the rating of book_id = 5 for user_id = 10
   def self.user_ratings_array user_id
      max_book_id = Book.maximum("id")
      book2rating = Array.new(max_book_id + 1)
      Rating.where( user_id: user_id ).each do |r|
          book2rating[r.book_id] = r.rating
      end
      book2rating.map { |x| x ||= 0 }
   end

end

# WARNING: removes all database data
# WARNING: does not reset the auto increment counters
# WARNING: to completely reset db, see reset-create.db
#
def load_test_data!
    Rating.destroy_all
    User.destroy_all
    Book.destroy_all
    
    Book.create(id: 1, title: "A", author: "Author A")
    Book.create(id: 2, title: "B", author: "Author B")
    Book.create(id: 3, title: "C", author: "Author C")

    User.create(id: 1, name: 'U1')
    User.create(id: 2, name: 'U2')
    User.create(id: 3, name: 'U3')

    Rating.create(user_id: 1, book_id: 1, rating: 5)
    Rating.create(user_id: 1, book_id: 2, rating: 0)    
    Rating.create(user_id: 1, book_id: 3, rating: 1)
    Rating.create(user_id: 2, book_id: 1, rating: 4)
    Rating.create(user_id: 2, book_id: 2, rating: 4)
    Rating.create(user_id: 3, book_id: 1, rating: 5)
    Rating.create(user_id: 3, book_id: 2, rating: -5)
    
    return true
end
