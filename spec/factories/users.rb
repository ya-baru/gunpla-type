FactoryBot.define do
  factory :user, class: "User" do
    sequence(:username) { |n| "user-#{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.current }

    trait :confirmation do
      email { "user@example.com" }
      confirmed_at { nil }
    end

    trait :account_lock do
      email { "user@example.com" }
      confirmed_at { Time.current }
      locked_at { Time.current }
    end

    trait :oauth do
      provider { "facebook" }
      uid { "1234" }
    end
  end
end
