FactoryBot.define do
  factory :user do
    name {Faker::FunnyName.name}
    email {Faker::Internet.free_email}
    password {"123123"}
    password_confirmation {"123123"}
    address {Faker::Address.full_address}
    phone {Faker::Number.leading_zero_number(digits: 10)}
    role {User.roles[:member]}
    activated_at {Time.zone.now}
  end
end
