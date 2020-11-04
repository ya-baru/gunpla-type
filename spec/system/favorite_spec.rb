require 'rails_helper'

RSpec.describe "Favorite", :js, type: :system do
  let!(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:gunpla) { create(:gunpla) }

  describe "お気に入り登録機能の動作チェック" do
    it "お気に入り登録のON/OFF動作をテストする" do
      # お気に入りボタンの表示チェック
      visit gunpla_path(gunpla)
      expect(page).not_to have_selector("#favorite_btn button", text: "お気に入り")

      sign_in user
      visit gunpla_path(gunpla)

      click_on "お気に入り"
      aggregate_failures do
        expect(page).to have_selector("#favorite_btn button", text: "登録済み")
        expect(user.favorites.count).to eq 1
      end

      click_on "登録済み"
      aggregate_failures do
        expect(page).to have_selector("#favorite_btn button", text: "お気に入り")
        expect(user.favorites.count).to eq 0
      end
    end
  end
end
