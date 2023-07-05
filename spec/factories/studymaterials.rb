FactoryBot.define do
  factory :studymaterial do
    textbook { "MyText" }
    association :chapter
  end
end
