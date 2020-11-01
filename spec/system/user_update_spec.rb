require 'rails_helper'

RSpec.describe "UserUpdate", type: :system do
  let!(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    sign_in user
    visit edit_user_registration_path
  end

  def expect_page_information(text)
    aggregate_failures do
      expect(page).to have_title("#{text} - GUNPLA-Type")
      expect(page).to have_selector("li.breadcrumb-item", text: "ホーム")
      expect(page).to have_selector("li.breadcrumb-item", text: "マイページ")
      expect(page).to have_selector("li.breadcrumb-item", text: text)
    end
  end

  describe "プロフィール編集テスト" do
    it "必要な情報を入力して更新させる" do
      expect_page_information("プロフィール編集")

      # 失敗
      fill_in "ユーザー名", with: ""
      fill_in "プロフィール", with: "li" * 256
      click_on "更新する"

      aggregate_failures do
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "プロフィールは255文字以内で入力してください"
      end

      # 成功
      fill_in "ユーザー名", with: "new-user"
      fill_in "プロフィール", with: "Vガンが好きです"
      attach_file "user[avatar]", "#{Rails.root}/spec/files/sample.jpg"
      click_on "更新する"

      aggregate_failures do
        expect(user.reload.avatar.attached?).to be_truthy
        expect(user.reload).to have_attributes(
          username: "new-user",
          profile: "Vガンが好きです",
        )
      end

      visit edit_user_registration_path
      expect(page).to have_selector("img[src$='sample.jpg']")
    end
  end

  describe "メールアドレス編集テスト" do
    it "必要な情報を入力して更新させる" do
      click_on "メールアドレス編集"
      expect_page_information("メールアドレス編集")

      # 失敗
      fill_in "user[email]", with: ""
      fill_in "user[email_confirmation]", with: ""
      click_on "更新する"

      aggregate_failures do
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "確認用メールアドレスを入力してください"
      end

      # 成功
      fill_in "user[email]", with: "new@example.com"
      fill_in "user[email_confirmation]", with: "new@example.com"

      aggregate_failures do
        expect { click_on "更新する" }.not_to change { ActionMailer::Base.deliveries.count }
        expect(user.reload.email).to eq "new@example.com"
      end
    end
  end

  describe "パスワード編集テスト" do
    it "必要な情報を入力して更新させる" do
      click_on "パスワード編集"
      expect_page_information("パスワード編集")

      # 失敗
      fill_in "user[password]", with: ""
      fill_in "user[password_confirmation]", with: ""
      fill_in "user[current_password]", with: ""
      click_on "更新する"

      aggregate_failures do
        expect(page).to have_content "パスワードを入力してください"
        expect(page).to have_content "確認用パスワードを入力してください"
        expect(page).to have_content "現在のパスワードを入力してください"
      end

      # 成功
      fill_in "user[password]", with: "new-password"
      fill_in "user[password_confirmation]", with: "new-password"
      fill_in "user[current_password]", with: user.password

      aggregate_failures do
        expect { click_on "更新する" }.not_to change { ActionMailer::Base.deliveries.count }
        expect(page).to have_selector(".alert-success", text: "パスワードが正しく変更されました。")
        # expect(user.reload.password).to eq "new-password"
      end
    end
  end

  describe "退会の手続きテスト" do
    it "確認画面を経てアカウントを削除する" do
      click_on "退会の手続き"
      expect_page_information("退会の手続き")

      aggregate_failures do
        expect { click_on "退会する" }.to change(User, :count).by(-1)
        expect(current_path).to eq root_path
        expect(page).to have_selector(".alert-success", text: "アカウントを削除しました。またのご利用をお待ちしております。")
      end
    end
  end
end
