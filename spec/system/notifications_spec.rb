require 'rails_helper'

RSpec.describe "Notifications", :js, type: :system do
  let!(:favorite) { create(:favorite) }
  let(:user) { User.first }
  let(:gunpla) { Gunpla.first }
  let(:other_user) { create(:user) }

  def expect_page_information(sub_title: nil, breadcrumb: nil)
    expect(page).to have_title("#{sub_title} - GUNPLA-Type")
    expect(page).to have_selector("li.breadcrumb-item", text: "ホーム")
    expect(page).to have_selector("li.breadcrumb-item", text: breadcrumb)
  end

  it "お気に入りガンプラのレビューに対するお知らせテストをする" do
    sign_in other_user
    visit gunpla_path(gunpla)

    click_on "お気に入り"
    expect(page).to have_content "登録済み"
    expect(Favorite.count).to eq 2

    click_on "『#{gunpla.name}』 をレビューする"
    fill_in "タイトル", with: "おすすめ！"
    fill_in "内容", with: "組み立てやすい！"
    page.all("img")[4].click
    attach_file "review[images][]",
                ["#{Rails.root}/spec/files/sample.jpg", "#{Rails.root}/spec/files/sample.jpg"],
                make_visible: true
    expect(page).to have_selector(".image-box img")

    # 自分とお気に入りユーザーのレコードが作成
    expect { click_on "レビューを投稿する" }.to change(Notification, :count).by(2)

    # アクティビティーチェック
    visit activities_path
    aggregate_failures do
      expect(page).to have_selector(".form-inline a", text: gunpla.name, count: 1)
      expect_page_information(sub_title: "アクティビティー", breadcrumb: "アクティビティー")
    end

    # お知らせチェック
    sign_out other_user
    sign_in user
    visit notifications_path
    aggregate_failures do
      expect_page_information(sub_title: "お知らせリスト", breadcrumb: "お知らせリスト")
      expect(page).to have_selector(".form-inline a", text: other_user.username, count: 1)
      expect(page).to have_selector(".form-inline a", text: gunpla.name, count: 1)
    end

    # OKクリックで項目を非表示
    click_on "全て確認済み"
    aggregate_failures do
      expect(Notification.first.checked).to be_truthy
      expect(current_path).to eq notifications_path
      expect(page).not_to have_selector(".form-inline a", text: other_user.username)
      expect(page).not_to have_selector(".form-inline a", text: gunpla.name)
      expect(page).to have_content("お知らせはありません")
    end
  end
end
