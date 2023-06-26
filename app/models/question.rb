class Question < ApplicationRecord
  has_many :choices

  validates :level, presence: true
  enum level: { level1: "level1", level2: "level2", level3: "level3" }

  validates :language, presence: true
  enum language: { Ruby: "Ruby", ReactJS: "ReactJS", ReactNative: "ReactNative" }
end
