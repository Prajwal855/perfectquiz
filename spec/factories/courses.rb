FactoryBot.define do
  factory :course do
    modul { "Sample Module" }
    association :category
    association :subcategory
  end
end
