require 'rails_helper'

RSpec.describe "Confirmation", type: :system do
  let(:user) { create(:user) }

  describe "アカウント有効化の案内メールの再送信チェック" do
    before { visit new_account_confirmation_path }

    context "アカウント未有効ユーザー" do
      let(:user) { create(:user, :unconfirmation) }

      it "案内ページからメール送信させる" do
        # 失敗
        aggregate_failures do
          expect(page).to have_title("確認メール再送信 - GUNPLA-Type")
          expect(page).to have_selector("a", text: "ホーム")
          expect(page).to have_selector("span", text: "確認メール再送信")

          expect { click_on "送信する" }.not_to change { ActionMailer::Base.deliveries.count }
          expect(page).to have_content("メールアドレスを入力してください")
        end

        # 成功
        fill_in "メールアドレス", with: user.email
        aggregate_failures do
          expect { click_on "送信する" }.to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(current_path).to eq account_confirmation_mail_sent_path
        end
      end
    end

    context "アカウント有効化ユーザー" do
      it "メールが送信されない" do
        fill_in "メールアドレス", with: user.email

        aggregate_failures do
          expect { click_on "送信する" }.not_to change { ActionMailer::Base.deliveries.count }
          expect(page).to have_content("メールアドレスは既に登録済みです。ログインしてください。")
        end
      end
    end
  end
end
