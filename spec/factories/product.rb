FactoryBot.define do
  factory :product do
    name {Faker::Name.name}
    information {Faker::Food.description}
    price {Faker::Number.decimal(l_digits: 2)}
    quantity {rand(11..20)}
    rating_score {4.4}
    category
  end
end
