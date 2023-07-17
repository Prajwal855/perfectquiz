class Intrest < ApplicationRecord
    has_one :academic
    validates :name , presence: true
end
