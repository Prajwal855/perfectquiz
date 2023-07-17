class Course < ApplicationRecord
    has_many :chapters

    validates :modul ,presence: true
end
