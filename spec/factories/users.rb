FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    role { User::ROLES[:user] }

    trait :admin do
      role { User::ROLES[:admin] }
    end
  end
end
