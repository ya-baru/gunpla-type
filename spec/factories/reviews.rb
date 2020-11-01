FactoryBot.define do
  factory :review, class: "Review" do
    sequence(:title) { |n| "おすすめ-#{n}" }
    content { "組み立てやすい！" }
    rate { 4 }
    likes_count { 0 }
    association :gunpla
    association :user

    after(:build) do |review|
      review.images.attach(
        io: File.open(Rails.root.join('spec', 'files', "sample.jpg")),
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
