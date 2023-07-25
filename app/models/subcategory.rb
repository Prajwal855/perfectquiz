class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :courses, dependent: :destroy
end
