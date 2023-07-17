class Chapter < ApplicationRecord
  belongs_to :course
  has_many :studymaterials

  validates :chap ,:course_id, presence: true
end
