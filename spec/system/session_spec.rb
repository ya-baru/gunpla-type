require 'rails_helper'

RSpec.describe "Session", type: :system do
  let!(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe "メールアドレスによるログインとログアウトの機能チェック" do
    it "登録情報でログイン後にログアウトをする" do
      visit new_user_session_path
      aggregate_failures do
        expect(page).to have_title("ログイン - GUNPLA-Type")
        expect(page).to have_selector("li", text: "ホーム")
        expect(page).to have_selector("li", text: "新規登録")
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
        expect(page).to have_selector("li", text: "お知らせ")
        expect(page).to have_selector("li", text: "ホーム")
        expect(page).to have_selector("li", text: "マイページ")
        expect(current_path).to eq mypage_path(user)
      end

      # ログアウト
      click_on "ログアウト"
      expect(current_path).to eq root_path
      expect(page).to have_selector(".alert-success", text: "ログアウトしました。")
    end
  end

  describe "remember機能のチェック", :js do
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

        travel_to 29.days.after do
          visit edit_user_registration_path
          expect(current_path).to eq edit_user_registration_path
        end

        travel_to 30.days.after do
          visit edit_user_registration_path
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
          visit edit_user_registration_path
          expect(page).to have_selector(".alert-danger", text: "ログインしてください。")
          expect(current_path).to eq new_user_session_path
        end
      end
    end
  end

  describe "管理者がログイン" do
    let(:admin) { create(:user, :admin) }

    it "管理者専用のダッシュボードへリダイレクトされる" do
      visit new_user_session_path

      fill_in "メールアドレス", with: admin.email
      fill_in "パスワード", with: admin.password
      click_on "ログインする"

      expect(current_path).to eq rails_admin_path
    end

    describe "ページリンクの表示チェック" do
      it "各要素の表示差異を検証する" do
        sign_in admin

        visit mypage_path(admin)
        aggregate_failures do
          expect(page).to have_content("管理者画面", count: 2)
          expect(page).to have_content("記事一覧", count: 2)
        end

        sign_out admin
        sign_in user
        visit mypage_path(user)
        aggregate_failures do
          expect(page).not_to have_content("管理者画面")
          expect(page).not_to have_content("記事一覧")
        end
      end
    end
  end
end
