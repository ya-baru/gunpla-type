FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "おすすめ-#{n}" }
    content { "組み立てやすい！" }
    rate { 5 }
    association :gunpla
    association :user
    trait :with_image do
      after(:build) do |review|
        review.images.attach(
          io: File.open(Rails.root.join('spec', 'files', "sample.jpg")),
          filename: 'sample.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
