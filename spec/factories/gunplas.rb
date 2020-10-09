FactoryBot.define do
  factory :gunpla, class: "Gunpla" do
    sequence(:name) { |n| "GUNPLA-#{n}" }
    sales_id { Sales.first.id }

    after(:build) do |gunpla|
      gunpla.category_id = create(:child_category).id
    end
  end
end
