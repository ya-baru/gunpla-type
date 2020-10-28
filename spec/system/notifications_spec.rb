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

  describe "お知らせの動作テスト" do
    it "お気に入り登録ガンプラのレビューに対するお知らせテストをする" do
      sign_in other_user
      visit gunpla_path(gunpla)

      click_on "『#{gunpla.name}』 をレビューする"
      fill_in "タイトル", with: "おすすめ！"
      fill_in "内容", with: "組み立てやすい！"
      page.all("img")[4].click
      attach_file "review[images][]", ["#{Rails.root}/spec/files/sample.jpg"], make_visible: true
      expect(page).to have_selector(".image-box img")

      # 自分とお気に入りユーザーのレコードが作成
      expect { click_on "レビューを投稿する" }.to change(Notification, :count).by(2)

      # アクティビティーチェック
      visit activities_path
      aggregate_failures do
        expect(page).to have_selector(".form-inline a", text: gunpla.name, count: 1)
        expect_page_information(sub_title: "アクティビティー", breadcrumb: "アクティビティー")
      end

      # レビュアーには表示されない
      visit notifications_path
      expect(page).not_to have_selector(".form-inline a", text: gunpla.name)

      # お気に入り登録ユーザー
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

  describe "非通知設定のテスト" do
    let!(:favorite) { create(:favorite_none_notice) }

    it "非通知の場合、自動的にお知らせがチェック済みに処理される" do
      sign_in other_user
      visit gunpla_path(gunpla)

      click_on "『#{gunpla.name}』 をレビューする"
      fill_in "タイトル", with: "おすすめ！"
      fill_in "内容", with: "組み立てやすい！"
      page.all("img")[4].click
      attach_file "review[images][]", ["#{Rails.root}/spec/files/sample.jpg"], make_visible: true
      expect(page).to have_selector(".image-box img")

      click_on "レビューを投稿する"
      expect(user.passive_notifications[0].action).to be_truthy

      sign_out other_user
      sign_in user
      visit notifications_path
      expect(page).to have_content("お知らせはありません")
    end
  end
end
