FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email { Faker::Internet.email}
    password { Faker::Internet.password(min_length: 8) }
    phonenumber { "+917019824855" }
  end
end
