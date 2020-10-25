require 'rails_helper'

RSpec.describe "Comments", type: :system do
  describe "コメント送信機能のテスト" do
    let!(:review) { create(:review) }
    let(:user) { User.first }

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

      expect(current_path).to eq review_path(review)
      expect(page).to have_selector(".alert-success", text: "コメント送信が完了しました")
      expect(page).to have_selector("#comment li", text: user.username)
      expect(page).to have_selector("#comment li", text: user.comments.first.created_at.to_s(:full_datetime_jp))
      expect(page).to have_selector("#comment li", text: "このキットいいですよね！")
    end
  end

  describe "コメント削除のテスト" do
    let!(:comment) { create(:comment) }
    let(:user) { User.first }
    let(:review) { Review.first }
    let(:other_user) { create(:user) }

    it "レビューページからコメントを削除する" do
      # 他ユーザーは非表示
      sign_in other_user
      visit review_path(review)
      expect(page).not_to have_selector("#comment li", text: "削除")
      sign_out other_user

      sign_in user
      visit review_path(review)
      expect { click_on "削除" }.to change(user.comments, :count).by(-1)
      expect(current_path).to eq review_path(review)
      expect(page).to have_selector(".alert-success", text: "コメントを削除しました")
    end
  end
end
