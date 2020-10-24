require 'rails_helper'

RSpec.describe "Iine", :js, type: :system do
  let!(:review) { create(:review) }
  let(:user) { User.first }
  let!(:other_user) { create(:user) }

  describe "いいね機能の動作チェック" do
    it "いいねのON/OFFの動作をテストする" do
      sign_in other_user
      visit review_path(review)

      click_on "いいね！"
      aggregate_failures do
        expect(page).to have_selector("#like_form button", text: "いいね中！")
        expect(Like.count).to eq 1
      end

      click_on "いいね中！"
      aggregate_failures do
        expect(page).to have_selector("#like_form button", text: "いいね！")
        expect(Like.count).to eq 0
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

      it { is_expected.not_to have_selector("#like_form button", text: "いいね！") }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.not_to have_selector("#like_form button", text: "いいね！") }
    end
  end
end
