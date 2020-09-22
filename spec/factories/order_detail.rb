FactoryBot.define do
  factory :order_detail do
    current_price {Faker::Number.decimal(l_digits: 2)}
    quantity {rand(1..10)}
    order
    product
  end
end
