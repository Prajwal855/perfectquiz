FactoryBot.define do
  factory :question do
      que { "Dummy Test" }
      correct_answer { "Option A" }
      level {"level1"}
      language {"Ruby"}
end
end
