FactoryBot.define do
  factory :choice do
    option { "Option A" }
      association :question
end
end
