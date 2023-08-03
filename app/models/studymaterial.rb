class Studymaterial < ApplicationRecord
  belongs_to :chapter
  has_one_attached :video
  has_one_attached :softcopy

  validates :textbook, :chapter_id, presence: true
end
