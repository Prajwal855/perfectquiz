class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :courses
  validates :name, :category_id, presence: true
end
