
require 'rspec'
require './lib/book-recsys.rb'

describe "book-recsys:" do
  around(:each) do |example|
    ActiveRecord::Base.transaction do    
      load_test_data!         
      example.run
      raise ActiveRecord::Rollback
    end
  end

  describe "num_non_zero_ratings" do
    context "given a book_id" do
      it "returns the number of non zero ratings for a book" do
        expect(num_non_zero_ratings(1)).to eq(3)
        expect(num_non_zero_ratings(2)).to eq(2)  
        expect(num_non_zero_ratings(3)).to eq(1)    
      end
    end
  end

  describe "average_book_rating" do
      context "given a book_id" do
          it "returns the average book rating" do
              expect(average_book_rating(1)).to be_within(0.001).of(4.667)
              expect(average_book_rating(2)).to be_within(0.001).of(-0.500)            
              expect(average_book_rating(3)).to eq(1.0)       
          end
      end
      context "given a book with no ratings" do
          it "returns zero" do
              book = Book.create(id: 4, title: "TestTitle", author: "TestAuthor")
              expect(average_book_rating(book.id)).to eq(0.0)
          end
      end
  end

  describe "book similarity" do
      context "given two book ids" do
          it "returns the cosine similarity" do
              expect(similarity(1,1)).to be_within(0.001).of(1.000)
              expect(similarity(2,2)).to be_within(0.001).of(1.000)
              expect(similarity(3,3)).to be_within(0.001).of(1.000)
              expect(similarity(1,2)).to be_within(0.001).of(-0.173)
              expect(similarity(1,3)).to be_within(0.001).of(0.615)
              expect(similarity(2,3)).to eq(0.0)
              expect(similarity(3,2)).to eq(0.0)
          end
      end
  end
    
end
