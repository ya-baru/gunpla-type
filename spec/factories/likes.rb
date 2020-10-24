FactoryBot.define do
  factory :like do
    association :review
    user { review.user }
  end
end
