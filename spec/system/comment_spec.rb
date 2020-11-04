require 'rails_helper'

RSpec.describe "Comment", type: :system do
  describe "コメント送信機能のテスト" do
    let!(:review) { create(:review) }
    let(:user) { review.user }
    let(:gunpla) { Gunpla.first }
    let(:other_user) { create(:user) }

    it "レビューページからコメントを送信する" do
      # ログアウト時は表示されない
      visit review_path(review)
      expect(page).not_to have_selector(".heading", text: "このレビューへのコメント")

      sign_in user
      visit review_path(review)

      # 失敗
      click_on "コメントを送信する"
      expect(page).to have_selector(".alert-danger", text: "コメント送信に失敗しました")

      # 成功
      fill_in "comment[content]", with: "このキットいいですよね！"
      click_on "コメントを送信する"
      aggregate_failures do
        expect(current_path).to eq review_path(review)
        expect(page).to have_selector(".alert-success", text: "コメント送信が完了しました")
        expect(page).to have_selector("#comment li", text: user.username)
        expect(page).to have_selector("#comment li", text: user.comments.first.created_at.to_s(:full_datetime_jp))
        expect(page).to have_selector("#comment li", text: "このキットいいですよね！")
        expect(Notification.count).to eq 1
      end

      # お知らせレコードは何度でも作成される
      fill_in "comment[content]", with: "旧キットの名作！"
      click_on "コメントを送信する"
      expect(Notification.count).to eq 2

      # アクティビティーチェック
      visit activities_path
      aggregate_failures do
        expect(page).to have_selector(".form-inline a", text: gunpla.name, count: 2)
        expect(page).to have_selector(".form-inline p", text: "このキットいいですよね！", count: 1)
        expect(page).to have_selector(".form-inline p", text: "旧キットの名作！", count: 1)
      end

      visit notifications_path
      expect(page).to have_content("お知らせはありません")

      # 他ユーザーがコメント
      sign_out user
      sign_in other_user
      visit review_path(review)
      fill_in "comment[content]", with: "プロポーションと可動の両立！"
      click_on "コメントを送信する"
      visit activities_path
      aggregate_failures do
        expect(page).to have_selector(".form-inline a", text: user.username, count: 1)
        expect(page).to have_selector(".form-inline p", text: "プロポーションと可動の両立！", count: 1)
      end

      # お知らせチェック
      sign_out other_user
      sign_in user
      visit notifications_path
      aggregate_failures do
        expect(page).to have_selector(".form-inline a", text: other_user.username, count: 1)
        expect(page).to have_selector(".form-inline a", text: gunpla.name, count: 1)
        expect(page).to have_selector(".form-inline p", text: "プロポーションと可動の両立！", count: 1)
      end

      # OKクリックで項目を非表示
      click_on "全て確認済み"
      aggregate_failures do
        expect(Notification.first.checked).to be_truthy
        expect(current_path).to eq notifications_path
        expect(page).not_to have_selector(".form-inline a", text: other_user.username)
        expect(page).not_to have_selector(".form-inline a", text: gunpla.name)
        expect(page).not_to have_selector(".form-inline p", text: "プロポーションと可動の両立！")
        expect(page).to have_content("お知らせはありません")
      end
    end
  end

  describe "コメント削除のテスト" do
    let!(:comment) { create(:comment) }
    let(:user) { comment.user }
    let(:review) { Review.first }
    let(:other_user) { create(:user) }

    it "レビューページからコメントを削除する", :js do
      # 他ユーザーは非表示
      sign_in other_user
      visit review_path(review)
      expect(page).not_to have_selector("#comment li", text: "削除")
      sign_out other_user

      sign_in user
      visit review_path(review)

      page.accept_confirm do
        click_on "削除"
      end

      aggregate_failures do
        sleep 0.5
        expect(user.reload.comments.count).to eq 0
        expect(current_path).to eq review_path(review)
      end
    end
  end
end
