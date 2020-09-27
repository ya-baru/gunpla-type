require 'rails_helper'

RSpec.describe "UserUpdate", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit edit_user_registration_path
  end

  describe "プロフィール編集テスト" do
    it "必要な情報を入力して更新させる" do
      expect(page).to have_title("プロフィール編集 - GUNPLA-Type")

      # 失敗
      fill_in "ユーザー名", with: ""
      fill_in "プロフィール", with: "a" * 256
      click_on "更新する"

      aggregate_failures do
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "プロフィールは255文字以内で入力してください"
      end

      # 成功
      fill_in "ユーザー名", with: "new-user"
      fill_in "プロフィール", with: "あいうえお"
      attach_file "user[avatar]", "#{Rails.root}/spec/files/sample.jpg"
      click_on "更新する"

      aggregate_failures do
        expect(current_path).to eq mypage_path(user)
        expect(page).to have_selector(".alert-success", text: "アカウント情報を変更しました。")
        expect(page).to have_selector("img[src$='sample.jpg']")
        expect(user.reload.username).to eq "new-user"
        expect(user.reload.profile).to eq "あいうえお"
      end
    end
  end

  describe "メールアドレス編集テスト" do
    it "必要な情報を入力して更新させる" do
      click_on "メールアドレス編集"
      expect(page).to have_title("メールアドレス編集 - GUNPLA-Type")

      # 失敗
      fill_in "新しいメールアドレス", with: ""
      fill_in "新しいメールアドレス（確認用）", with: ""
      click_on "更新する"

      aggregate_failures do
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "新しいメールアドレス（確認用）を入力してください"
      end

      # 成功
      fill_in "新しいメールアドレス", with: "new@example.com"
      fill_in "新しいメールアドレス（確認用）", with: "new@example.com"

      aggregate_failures do
        expect { click_on "更新する" }.not_to change { ActionMailer::Base.deliveries.count }
        expect(current_path).to eq mypage_path(user)
        expect(page).to have_selector(".alert-success", text: "メールアドレスが正しく変更されました。")
        expect(user.reload.email).to eq "new@example.com"
      end
    end
  end

  describe "パスワード編集テスト" do
    it "必要な情報を入力して更新させる" do
      click_on "パスワード編集"
      expect(page).to have_title("パスワード編集 - GUNPLA-Type")

      # 失敗
      fill_in "新しいパスワード", with: ""
      fill_in "確認用パスワード", with: ""
      fill_in "現在のパスワード", with: ""
      click_on "更新する"

      aggregate_failures do
        expect(page).to have_content "パスワードを入力してください"
        expect(page).to have_content "確認用パスワードを入力してください"
        expect(page).to have_content "現在のパスワードを入力してください"
      end

      # 成功
      fill_in "新しいパスワード", with: "new-password"
      fill_in "確認用パスワード", with: "new-password"
      fill_in "現在のパスワード", with: user.password

      aggregate_failures do
        expect { click_on "更新する" }.not_to change { ActionMailer::Base.deliveries.count }
        expect(current_path).to eq mypage_path(user)
        expect(page).to have_selector(".alert-success", text: "パスワードが正しく変更されました。")
        # expect(user.reload.password).to eq "new-password"
      end
    end
  end

  describe "退会の手続きテスト" do
    it "確認画面を経てアカウントを削除する" do
      click_on "退会の手続き"

      aggregate_failures do
        expect(page).to have_title("退会の手続き - GUNPLA-Type")
        expect { click_on "退会する" }.to change(User, :count).by(-1)
        expect(current_path).to eq root_path
        expect(page).to have_selector(".alert-success", text: "アカウントを削除しました。またのご利用をお待ちしております。")
      end
    end
  end
end
