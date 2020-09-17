# Orders
6.times do |n|
  Order.create!(
    user_id: User.admin.pluck(:id).sample,
    status: Order.statuses.values.sample,
    total: 0
    )
end

6.times do |n|
  Order.create!(
    user_id: User.limit(3).pluck(:id).sample,
    status: Order.statuses.values.sample,
    total: 0
    )
end

# Orders Details
20.times do |n|
  OrderDetail.create!(
    order_id: Order.pluck(:id).sample,
    product_id: Product.pluck(:id).sample,
    current_price: Faker::Number.decimal(l_digits: 2),
    quantity: rand(1..10)
    )
end
