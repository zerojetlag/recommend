class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :student_number, :count
  validates_uniqueness_of :student_number
  has_and_belongs_to_many :books
end
