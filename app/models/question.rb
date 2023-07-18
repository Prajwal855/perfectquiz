class Question < ApplicationRecord
  has_many :choices

  validates :level, :que, :correct_answer, presence: true
  enum level: { level1: "level1", level2: "level2", level3: "level3" }

  validates :language, presence: true
  enum language: { Ruby: "Ruby", ReactJS: "ReactJS", ReactNative: "ReactNative" }

  accepts_nested_attributes_for :choices, reject_if: :all_blank, allow_destroy: true
end
