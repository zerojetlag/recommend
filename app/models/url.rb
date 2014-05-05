class Url < ActiveRecord::Base
  attr_accessible :name, :url
  validates_uniqueness_of :name
end
