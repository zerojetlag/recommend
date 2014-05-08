class Url < ActiveRecord::Base
  attr_accessible :name, :url, :image
  validates_uniqueness_of :name
end
