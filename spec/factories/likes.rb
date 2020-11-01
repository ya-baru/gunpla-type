FactoryBot.define do
  factory :like, class: "Like" do
    association :review
    user { review.user }
  end
end
