require 'rails_helper'

RSpec.describe "Mypage", type: :system do
  describe "マイページへのアクセスチェック" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit mypage_path(other_user)
    end

    context "他ユーザー" do
      let(:other_user) { create(:user) }

      it "プロフィール編集機能が制限されたページへアクセスする" do
        expect(page).to have_content(other_user.username)
      end
    end

    context "存在しないユーザー" do
      let(:other_user) { build(:user, id: 2) }

      it "ホームへリダイレクトされる" do
        expect(current_path).to eq root_path
      end
    end
  end
end
