# Categories
Category.create!(name: "Foods")
Category.create!(name: "Drinks")

# Products
categories = Category.all
categories.each do |category|
  10.times do |n|
    Product.create!(
      category_id: category.id,
      name: category.name + " #{n+1}",
      information: Faker::Food.description,
      price: Faker::Number.decimal(l_digits: 2),
      quantity: Faker::Number.non_zero_digit,
      rating_score: 4.4
      )
  end
end
