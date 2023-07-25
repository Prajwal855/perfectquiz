class Course < ApplicationRecord
    belongs_to :subcategory
    has_one :category, through: :subcategory
    has_many :chapters

    validates :modul ,presence: true
end
