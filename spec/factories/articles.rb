FactoryBot.define do
  factory :article, class: "Article" do
    title { "新着記事" }
    content { "コンテンツ" }
    building { "ガンダムベース東京" }
    address { " 東京都江東区青海1-1-10 ダイバーシティ東京 プラザ7F" }
    latitude { "35.6251856" }
    longitude { "139.7756314" }

    trait :with_image do
      after(:build) do |article|
        article.image.attach(io: File.open(
          Rails.root.join('spec', 'files', "sample.jpg")
        ), filename: 'sample.jpg', content_type: 'image/jpeg')
      end
    end

    trait :update do
      title { "記事更新" }
    end
  end
end
