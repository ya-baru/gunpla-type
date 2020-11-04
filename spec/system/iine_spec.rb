require 'rails_helper'

RSpec.describe "like", :js, type: :system do
  let!(:admin) { create(:user, :admin) }
  let!(:review) { create(:review) }
  let(:user) { review.user }
  let!(:other_user) { create(:user) }

  describe "いいね機能の動作チェック" do
    it "いいねのON/OFF動作＋お知らせ機能をテストする" do
      sign_in other_user
      visit review_path(review)

      click_on "いいね！"
      aggregate_failures do
        expect(page).to have_selector("#like_btn button", text: "いいね中！")
        expect(other_user.likes.count).to eq 1
        expect(Notification.count).to eq 1
      end

      click_on "いいね中！"
      aggregate_failures do
        expect(page).to have_selector("#like_btn button", text: "いいね！")
        expect(other_user.likes.count).to eq 0
      end

      # 連続クリックしても通知カウントは反映されない
      click_on "いいね！"
      expect(Notification.count).to eq 1

      # アクティビティーチェック
      visit activities_path
      expect(page).to have_selector(".form-inline a", text: user.username, count: 1)

      # お知らせチェック
      sign_out other_user
      sign_in user
      visit notifications_path
      aggregate_failures do
        expect(page).to have_selector(".form-inline a", text: other_user.username, count: 1)
        expect(page).to have_selector(".form-inline a", text: review.gunpla.name, count: 1)
      end

      # OKクリックで項目を非表示
      click_on "全て確認済み"
      aggregate_failures do
        expect(Notification.first.checked).to be_truthy
        expect(current_path).to eq notifications_path
        expect(page).not_to have_selector(".form-inline a", text: other_user.username)
        expect(page).not_to have_selector(".form-inline a", text: review.gunpla.name)
        expect(page).to have_content("お知らせはありません")
      end
    end
  end

  describe "いいねボタンの表示チェック" do
    subject { page }

    before do
      login
      visit review_path(review)
    end

    context "レビュアー" do
      let(:login) { sign_in user }

      it { is_expected.not_to have_selector("#like_btn button", text: "いいね！") }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.not_to have_selector("#like_btn button", text: "いいね！") }
    end
  end
end
