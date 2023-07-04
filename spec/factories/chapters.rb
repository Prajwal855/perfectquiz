FactoryBot.define do
  factory :chapter do
    chap { "MyString" }
    association :course
  end
end
