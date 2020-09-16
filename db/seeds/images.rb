# Images
c1 = Category.find_by name: "Foods"
c2 = Category.find_by name: "Drinks"
food_products = c1.products
drink_products = c2.products

food_products.each do |product|
  product.images.create!(
    image_url: "food.jpg"
    )
end

drink_products.each do |product|
  product.images.create!(
    image_url: "drink.jpg"
    )
end

User.first.images.create!(
  image_url: "user.png"
)
