
require 'pg'
require 'active_record'

ActiveRecord::Base.establish_connection(
	    :adapter => "postgresql",
	    :username => "codio",
	  # :password => "codio",
        :database => "bookratings")
		
		
ActiveRecord::Schema.define do
  create_table( :books, force: :cascade ) do |t|
    t.string :title,  null: false 
    t.string :author, null: false 
  end

  create_table( :users, force: :cascade ) do |t|
    t.string :name, null: false 
  end

  create_table( :ratings, primary_key: [:user_id, :book_id], force: true ) do |t|
    t.integer :rating, null: false 
    t.belongs_to :user, null: false, foreign_key: true 
    t.belongs_to :book, null: false, foreign_key: true
  end
end


