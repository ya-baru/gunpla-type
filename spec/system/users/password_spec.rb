require 'rails_helper'

RSpec.describe "Password", type: :system do
  let(:user) { create(:user) }

  describe "パスワードリセット方法の案内メールの送信チェック" do
    before { visit new_reset_password_path }

    context "アカウント有効化ユーザー" do
      it "案内ページからメール送信させる" do
        # 失敗
        aggregate_failures do
          expect(page).to have_title("パスワード再設定の方法 - GUNPLA-Type")
          expect(page).to have_selector("li", text: "ホーム")
          expect(page).to have_selector("li", text: "パスワード再設定の方法")

          expect { click_on "送信する" }.not_to change { ActionMailer::Base.deliveries.count }
          expect(page).to have_content("メールアドレスを入力してください")
        end

        # 成功
        fill_in "メールアドレス", with: user.email
        aggregate_failures do
          expect { click_on "送信する" }.to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(current_path).to eq password_reset_mail_sent_path
        end
      end
    end

    context "アカウント未有効化ユーザー" do
      let(:unconfirm_user) { create(:user, :unconfirmation) }

      it "メールが送信されない" do
        fill_in "メールアドレス", with: unconfirm_user.email
        aggregate_failures do
          expect { click_on "送信する" }.not_to change { ActionMailer::Base.deliveries.count }
          expect(page).to have_content("アカウントが有効化されていません。メールに記載された手順にしたがって、アカウントを有効化してください。")
          expect(current_path).to eq root_path
        end
      end
    end
  end

  describe "パスワードリセットページへのアクセスチェック" do
    let!(:user) { create(:user) }

    it "不正なアクセスなら制限をすること" do
      visit edit_password_path
      expect(current_path).to eq new_user_session_path
    end
  end
end
