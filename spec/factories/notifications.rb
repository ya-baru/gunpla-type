FactoryBot.define do
  factory :notification, class: "Notification" do
    association :visitor, factory: :user
    association :visited, factory: :user
    action { "follow" }
    checked { false }
  end
end
