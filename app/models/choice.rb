class Choice < ApplicationRecord
  belongs_to :question
  validates :option ,:question_id, presence: true
end
