FactoryBot.define do
  factory :subcategory do
    name { "Sample Subcategory" }
    association :category
  end
end
