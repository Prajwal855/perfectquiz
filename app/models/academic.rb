class Academic < ApplicationRecord
  belongs_to :intrest
  belongs_to :qualification
  belongs_to :user
  has_one_attached :governament_id
  has_one_attached :cv

  validates :college_name, :intrest_id, :qualification_id,
   :career_goals, :language, :other_language, :specialization, :governament_id, :cv,
    :experiance, :user_id, presence: true

  validates_uniqueness_of :user_id
end
