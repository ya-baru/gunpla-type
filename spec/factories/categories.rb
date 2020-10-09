FactoryBot.define do
  factory :category, class: "Category" do
    name { "1/144" }
    ancestry { nil }

    factory :parent_category do |p|
      p.parent { create(:category, name: "機動戦士ガンダム") }

      factory :child_category do |c|
        c.parent { create(:parent_category, name: "HGUC") }
      end
    end
  end
end
