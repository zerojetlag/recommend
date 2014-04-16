class Book < ActiveRecord::Base
  attr_accessible :book_number, :name, :author, :publisher, :born_year, :isbn, :shelf, :first_category, :second_category
  validates_uniqueness_of :isbn
  has_and_belongs_to_many :users
end
