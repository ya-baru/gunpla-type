require 'rails_helper'

RSpec.describe "Relationship", :js, type: :system do
  let(:review) { create(:review) }
  let(:followed) { review.user }
  let(:follower) { create(:user) }

  describe "フォロー機能の動作チェック" do
    it "フォローのON/OFF動作＋お知らせ機能をテストする" do
      sign_in follower
      visit review_path(review)

      click_on "フォロー"
      aggregate_failures do
        expect(page).to have_selector("#follow_btn button", text: "フォロー中")
        expect(follower.following.count).to eq 1
        expect(Notification.count).to eq 1
      end

      click_on "フォロー中"
      aggregate_failures do
        expect(page).to have_selector("#follow_btn button", text: "フォロー")
        expect(follower.following.count).to eq 0
      end

      # 連続クリックしても通知カウントは反映されない
      click_on "フォロー"
      expect(Notification.count).to eq 1

      # アクティビティーチェック
      visit activities_path
      expect(page).to have_selector(".form-inline a", text: followed.username, count: 1)

      # お知らせチェック
      sign_out follower
      sign_in followed
      visit notifications_path
      expect(page).to have_selector(".form-inline a", text: follower.username, count: 1)

      # OKクリックで項目を非表示
      click_on "全て確認済み"
      aggregate_failures do
        expect(Notification.first.checked).to be_truthy
        expect(current_path).to eq notifications_path
        expect(page).not_to have_selector(".form-inline a", text: follower.username)
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

    context "同一ユーザー" do
      let(:login) { sign_in followed }

      it { is_expected.not_to have_selector("#follow_btn button", text: "フォロー") }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.not_to have_selector("#follow_btn button", text: "フォロー") }
    end
  end
end
