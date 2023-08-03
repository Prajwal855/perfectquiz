class Course < ApplicationRecord
    belongs_to :category
    belongs_to :subcategory
    validates :modul, :category_id, :subcategory_id, presence: true
  end
