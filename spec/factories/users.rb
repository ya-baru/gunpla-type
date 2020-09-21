FactoryBot.define do
  factory :user, class: "User" do
    sequence(:username) { |n| "user-#{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.current }

    trait :unconfirmation do
      email { "user@example.com" }
      confirmation_token { Devise.token_generator.generate(User, :confirmation_token) }
      confirmed_at { nil }
    end

    trait :account_lock do
      email { "user@example.com" }
      locked_at { Time.current }
    end

    trait :oauth do
      provider { "facebook" }
      uid { "1234" }
    end
  end
end
