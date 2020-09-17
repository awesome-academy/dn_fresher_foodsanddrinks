# Users
5.times do |n|
  User.create!(
    name: Faker::FunnyName.name,
    email: "yin2#{n+1}@gmail.com",
    address: Faker::Address.full_address,
    phone: Faker::Number.leading_zero_number(digits: 10),
    role: 0,
    password:"123123",
    password_confirmation: "123123",
    confirmed_at: Time.zone.now)
end
