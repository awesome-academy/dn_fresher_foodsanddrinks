FactoryBot.define do
  factory :product do
    name {Faker::Name.name}
    information {Faker::Food.description}
    price {Faker::Number.decimal(l_digits: 2)}
    quantity {Faker::Number.non_zero_digit}
    category_id {1}
    rating_score {4.4}
  end
end
