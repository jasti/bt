# == Schema Information
#
# Table name: categories
#
#  id                  :integer          not null, primary key
#  category_name       :string(255)
#
class User < ActiveRecord::Base
  validates: category_name, presence: true, length: { maximum: 100 }, :uniqueness => true
end