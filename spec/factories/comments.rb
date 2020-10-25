FactoryBot.define do
  factory :comment do
    content { "このキットいいですよね！" }
    association :review
    user { review.user }
  end
end
