require 'rails_helper'

RSpec.describe "Signup", type: :system do
  let(:valid_token) { User.last.confirmation_token }

  describe "新規ユーザー登録からアカウントの有効化までのチェック" do
    it "有効な情報を入力後、メール認証からアカウントを有効にする" do
      visit new_user_registration_path
      expect(page).to have_title("新規ユーザー登録 - GUNPLA-Type")

      # 無効な情報を送信
      click_on "アカウントを作成する"
      aggregate_failures do
        expect(page).to have_selector(".alert-danger", text: "ユーザー名を入力してください")
        expect(page).to have_selector(".alert-danger", text: "メールアドレスを入力してください")
        expect(page).to have_selector(".alert-danger", text: "パスワードを入力してください")
      end

      # 有効な情報を送信
      fill_in "ユーザー名", with: "user"
      fill_in "メールアドレス", with: "user@example.com"
      fill_in "パスワード", with: "password"
      fill_in "確認用パスワード", with: "password"
      click_on "アカウントを作成する"

      # 確認画面へ移動、入力情報を確認
      aggregate_failures do
        expect(page).to have_title "登録確認 - GUNPLA-Type"
        expect(current_path).to eq signup_confirm_path
        expect(all('tbody tr')[0]).to have_content "user"
        expect(all('tbody tr')[1]).to have_content "user@example.com"
        expect(all('tbody tr')[2]).to have_content "password"
      end

      # 一度、『戻る』ボタンで入力画面へ戻りパスワード関連のみ入力
      click_on "戻る"
      aggregate_failures do
        expect(page).to have_field "ユーザー名", with: "user"
        expect(page).to have_field "メールアドレス", with: "user@example.com"
        expect(page).not_to have_field "パスワード", with: "password"
        expect(page).not_to have_field "確認用パスワード", with: "password"
      end
      fill_in "パスワード", with: "password"
      fill_in "確認用パスワード", with: "password"
      click_on "アカウントを作成する"

      # 『確定』ボタンをクリックでメールが送信され、送信完了画面へリダイレクトされる
      aggregate_failures do
        expect { click_on "確定" }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(current_path).to eq account_confirmation_mail_sent_path
        expect(page).to have_title("送信完了 - GUNPLA-Type")
        click_on "トップページへ戻る"
        expect(current_path).to eq root_path
      end

      # 無効なトークンでアクセスする
      visit confirmation_path(confirmation_token: "invalid_token")
      aggregate_failures do
        expect(current_path).to eq confirmation_path
        expect(User.first.confirmed_at).to eq nil
      end

      # 有効なトークンでアクセスする
      visit confirmation_path(confirmation_token: valid_token)
      aggregate_failures do
        expect(current_path).to eq new_user_session_path
        expect(page).to have_selector(".alert-success", text: "メールアドレスが確認できました。")
        expect(User.first.confirmed_at).not_to eq nil
      end

      # もう一度アクセスするとエラーになる
      visit confirmation_path(confirmation_token: valid_token)
      aggregate_failures do
        expect(current_path).to eq confirmation_path
        expect(page).to have_content("メールアドレスは既に登録済みです。")
      end
    end
  end

  describe "認証トークンの有効期限（１日）チェック" do
    def signup_info
      visit new_user_registration_path
      fill_in "ユーザー名", with: "user"
      fill_in "メールアドレス", with: "user@example.com"
      fill_in "パスワード", with: "password"
      fill_in "確認用パスワード", with: "password"
      click_on "アカウントを作成する"
      click_on "確定"
    end

    context "有効期限内" do
      it "アカウントが有効になる" do
        signup_info
        travel_to 24.hours.after do
          visit confirmation_path(confirmation_token: valid_token)
          aggregate_failures do
            expect(current_path).to eq new_user_session_path
            expect(page).to have_selector(".alert-success", text: "メールアドレスが確認できました。")
            expect(User.first.confirmed_at).not_to eq nil
          end
        end
      end
    end

    context "有効期限経過" do
      it "アカウントが有効にならない" do
        signup_info
        travel_to 25.hours.after do
          visit confirmation_path(confirmation_token: valid_token)
          aggregate_failures do
            expect(current_path).to eq confirmation_path
            expect(page).to have_content("メールアドレスの期限が切れました。1日 までに確認する必要があります。 新しくリクエストしてください。")
            expect(User.first.confirmed_at).to eq nil
          end
        end
      end
    end
  end
end
