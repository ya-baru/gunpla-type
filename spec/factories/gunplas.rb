FactoryBot.define do
  factory :gunpla, class: "Gunpla" do
    sequence(:name) { |n| "GUNPLA-#{n}" }
    sales { "一般販売" }
    category_id { create(:child_category).id }
    favorites_count { 0 }
  end

  trait :update do
    name { "ガンプラ" }
  end
end
