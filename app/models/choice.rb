class Choice < ApplicationRecord
  belongs_to :question
  validates :option, presence: true
end
