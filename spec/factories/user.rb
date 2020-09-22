FactoryBot.define do
  factory :user do
    name {Faker::FunnyName.name}
    email {Faker::Internet.free_email}
    password {"123123"}
    password_confirmation {"123123"}
    address {Faker::Address.full_address}
    phone {Faker::Number.leading_zero_number(digits: 10)}

    trait :member do
      role {User.roles[:member]}
    end

    trait :admin do
      role {User.roles[:admin]}

    confirmed_at {Time.now}
    end
  end
end
