FactoryBot.define do
  factory :favorite do
    association :user
    association :gunpla

    factory :favorite_none_notice do
      association :user, :none_notice
    end
  end
end
