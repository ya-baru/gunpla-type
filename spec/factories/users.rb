FactoryBot.define do
  factory :user, class: "User" do
    sequence(:username) { |n| "user-#{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.current }
    reviews_count { 0 }
    likes_count { 0 }
    favorites_count { 0 }
    relationships_count { 0 }

    trait :admin do
      admin_flg { true }
    end

    trait :unconfirmation do
      email { "user@example.com" }
      confirmation_token { Devise.token_generator.generate(User, :confirmation_token) }
      confirmed_at { nil }
    end

    trait :account_lock do
      email { "user@example.com" }
      locked_at { Time.current }
    end

    trait :omniauth do
      provider { "facebook" }
      uid { "12345678" }
    end

    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(io: File.open(
          Rails.root.join('spec', 'files', "sample.jpg")
        ), filename: 'sample.jpg', content_type: 'image/jpeg')
      end
    end

    trait :with_profile do
      profile { "ファーストが一番好きです" }
    end

    trait :none_notice do
      notice { false }
    end

    trait :update do
      username { "アムロ" }
    end
  end
end
