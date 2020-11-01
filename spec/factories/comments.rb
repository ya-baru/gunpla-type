FactoryBot.define do
  factory :comment, class: "Comment" do
    content { "このキットいいですよね！" }
    association :review
    user { review.user }
  end
end
