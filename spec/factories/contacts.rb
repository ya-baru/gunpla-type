FactoryBot.define do
  factory :contact, class: "Contact" do
    name { "contact_user" }
    email { "contact@example.com" }
    message { "お問い合わせ" }
  end
end
