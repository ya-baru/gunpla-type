require 'rails_helper'

RSpec.describe "Users::Unlocks", type: :request do
  subject { response }

  let(:user) { create(:user) }

  before do
    login
    url
  end

  describe "#new" do
    let(:url) { get new_account_unlock_path }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(200) }
    end
  end

  describe "#create" do
    let(:url) do
      post account_unlock_path, params: { user: { email: user.email } }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it "メール送信せずリダイレクトすること" do
        expect(ActionMailer::Base.deliveries.count).to eq 0
        expect(response).to have_http_status 302
        expect(response).to redirect_to mypage_path(user)
      end
    end

    context "アカウント未凍結ユーザー" do
      let(:login) { nil }

      it "メール送信しないこと" do
        expect(ActionMailer::Base.deliveries.count).to eq 0
        expect(response).to have_http_status 200
      end
    end

    context "アカウント凍結ユーザー" do
      let(:login) { nil }
      let(:user) { create(:user, :account_lock) }

      it "メール送信すること" do
        aggregate_failures do
          expect(ActionMailer::Base.deliveries.count).to eq 1
          expect(response).to have_http_status 302
          expect(response).to redirect_to unlock_mail_sent_path
        end
      end
    end

    context "アカウント未有効化ユーザー" do
      let(:user) { create(:user, :unconfirmation) }
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to root_path }
      it "フラッシュメッセージが表示されること" do
        aggregate_failures do
          expect(flash[:danger]).to eq "アカウントが有効化されていません。<br>メールに記載された手順にしたがって、アカウントを有効化してください。"
        end
      end
    end
  end

  describe "#show" do
    let(:login) { nil }
    let(:url) { nil }

    describe "案内メールからの凍結解除をテストする" do
      context "不正なアクセス" do
        let(:lock_user) { create(:user, :account_lock) }

        it "凍結解除がされないこと" do
          get unlock_path
          aggregate_failures do
            expect(response).to have_http_status(200)
            expect(lock_user.locked_at).not_to eq nil
          end
        end
      end

      context "有効なアクセス" do
        let(:valid_token) { User.last.unlock_token }

        def login_error
          post user_session_path, params: { user: { email: user.email, password: "miss" } }
        end

        def extract_unlock_url(mail)
          body = mail.html_part.body.encoded
          body[/http[^"]+/]
        end

        before do
          login_error
          login_error
          login_error
        end

        it "案内メールを通じて凍結を解除すること" do
          expect { login_error }.to change { ActionMailer::Base.deliveries.count }.by(1)
          get extract_unlock_url(ActionMailer::Base.deliveries.last)

          aggregate_failures do
            expect(user.locked_at).to eq nil
            expect(response).to redirect_to new_user_session_url
            expect(flash[:notice]).to eq "アカウントを凍結解除しました。"
          end

          # 再アクセス
          get extract_unlock_url(ActionMailer::Base.deliveries.last)
          expect(response).to have_http_status 200
        end
      end
    end
  end
end
