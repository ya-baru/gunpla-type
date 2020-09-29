require 'rails_helper'

RSpec.describe "Session", type: :system do
  let(:user) { create(:user) }

  describe "メールアドレスによるログインとログアウトの機能チェック" do
    it "登録情報でログイン後にログアウトをする" do
      visit new_user_session_path
      aggregate_failures do
        expect(page).to have_title("ログイン - GUNPLA-Type")
        expect(page).to have_selector("li", text: "ホーム")
        expect(page).to have_selector("li", text: "ログイン")
      end

      # ログイン失敗
      click_on "ログインする"
      expect(page).to have_selector(".alert-danger", text: "メールアドレスまたはパスワードが違います。")

      # ログイン成功
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_on "ログインする"

      aggregate_failures do
        expect(page).to have_content("ログインしました")
        expect(page).to have_title("マイページ - GUNPLA-Type")
        expect(page).to have_selector("li", text: "ホーム")
        expect(page).to have_selector("li", text: "マイページ")
        expect(current_path).to eq mypage_path(user)
      end

      # ログアウト
      click_on "ログアウト"
      aggregate_failures do
        expect(current_path).to eq root_path
        expect(page).to have_selector(".alert-success", text: "ログアウトしました。")
      end
    end
  end

  describe "remember機能のチェック" do
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      remember
      click_on "ログインする"
    end

    context "remember ON" do
      let(:remember) { check "ログインを記憶" }

      it "３０日後に自動でログアウトする" do
        expect(user.reload.remember_created_at).not_to eq nil
        travel_to 30.days.after do
          expect(current_path).to eq mypage_path(user)
        end

        travel_to 31.days.after do
          visit mypage_path(user)
          expect(page).to have_selector(".alert-danger", text: "ログインしてください。")
          expect(current_path).to eq new_user_session_path
        end
      end
    end

    context "remember OFF" do
      let(:remember) { uncheck "ログインを記憶" }

      it "１時間経過でタイムアウトする" do
        expect(user.reload.remember_created_at).to eq nil
        travel_to 60.minutes.after do
          visit mypage_path(user)
          expect(page).to have_selector(".alert-danger", text: "ログインしてください。")
          expect(current_path).to eq new_user_session_path
        end
      end
    end
  end
end
