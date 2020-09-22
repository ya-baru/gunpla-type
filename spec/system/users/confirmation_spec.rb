require 'rails_helper'

RSpec.describe "Confirmation", type: :system do
  describe "アカウント有効化の案内メールの再送信チェック" do
    let(:user) { create(:user) }

    before { visit new_account_confirmation_path }

    context "アカウント未有効" do
      let(:user) { create(:user, :unconfirmation) }

      it "メールが送信される" do
        aggregate_failures do
          expect(page).to have_title("確認メール再送信 - GUNPLA-Type")
          expect { click_on "送信する" }.not_to change { ActionMailer::Base.deliveries.count }
          expect(page).to have_content("メールアドレスを入力してください")
        end

        fill_in "メールアドレス", with: user.email
        aggregate_failures do
          expect { click_on "送信する" }.to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(current_path).to eq account_confirmation_mail_sent_path
        end
      end
    end

    context "アカウント有効済み" do
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
