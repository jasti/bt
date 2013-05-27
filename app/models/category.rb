class Category < ActiveRecord::Base
  attr_accessible :category_name
  validates :category_name, presence: true,length: { maximum: 100 }, :uniqueness => true
end
