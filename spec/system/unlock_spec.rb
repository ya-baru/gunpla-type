require 'rails_helper'

RSpec.describe "Unlock", :js, type: :system do
  describe "アカウント凍結解除方法の案内メールの再送信チェック" do
    let!(:admin) { create(:user, :admin) }
    let!(:user) { create(:user) }

    context "アカウント凍結ユーザー" do
      def login_error
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "miss"
        click_on "ログインする"
      end

      before do
        visit new_user_session_path
        login_error
      end

      it "アカウントを凍結させてからメールを再送信させる" do
        # 警告のチェック
        aggregate_failures do
          login_error
          expect(page).to have_selector(".alert-danger", text: "メールアドレスまたはパスワードが違います。")
          login_error
          expect(page).to have_selector(".alert-danger", text: "もう一回誤るとアカウントがロックされます。")
          expect { login_error }.to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(page).to have_selector(".alert-danger", text: "アカウントは凍結されています。時間経過またはメールに記載された手順にしたがって、凍結解除してください。")
        end

        # 再送信
        visit new_account_unlock_path
        aggregate_failures do
          expect(page).to have_title("アカウント凍結解除の方法 - GUNPLA-Type")
          expect(page).to have_selector("li.breadcrumb-item", text: "ホーム")
          expect(page).to have_selector("li.breadcrumb-item", text: "アカウント凍結解除の方法")

          expect { click_on "送信する" }.not_to change { ActionMailer::Base.deliveries.count }
          expect(page).to have_content("メールアドレスを入力してください")
        end

        fill_in "メールアドレス", with: user.email
        aggregate_failures do
          expect { click_on "送信する" }.to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(current_path).to eq unlock_mail_sent_path
        end
      end

      it "アカウント凍結後、１時間経過で解除される" do
        login_error
        login_error
        login_error
        travel_to 61.minutes.after do
          fill_in "メールアドレス", with: user.email
          fill_in "パスワード", with: user.password
          click_on "ログインする"
          expect(current_path).to eq mypage_path(user)
        end
      end
    end

    context "アカウント未有効化ユーザー" do
      let(:unconfirm_user) { create(:user, :unconfirmation) }

      before { visit new_account_unlock_path }

      it "メールが送信されない" do
        fill_in "メールアドレス", with: unconfirm_user.email
        aggregate_failures do
          expect { click_on "送信する" }.not_to change { ActionMailer::Base.deliveries.count }
          expect(page).to have_content("カウントが有効化されていません。\nメールに記載された手順にしたがって、アカウントを有効化してください。")
          expect(current_path).to eq root_path
        end
      end
    end
  end
end
