FactoryBot.define do
  factory :favorite, class: "Favorite" do
    association :user
    association :gunpla

    factory :favorite_none_notice do
      association :user, :none_notice
    end
  end
end
