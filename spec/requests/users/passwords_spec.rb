require 'rails_helper'

RSpec.describe "Users::Passwords", type: :request do
  subject { response }

  let(:user) { create(:user) }

  describe "#new" do
    before do
      login
      get new_reset_password_path
    end

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
    before do
      login
      post reset_password_path, params: {
        user: { email: user.email },
      }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(user) }
      it "メール送信しないこと" do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it "メール送信すること" do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end
    end

    context "アカウント凍結ユーザー" do
      let(:user) { create(:user, :account_lock) }
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to password_reset_mail_sent_path }
      it "メール送信すること" do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end
    end
  end

  describe "#edit #update" do
    before do
      @raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      @params = { user: {
        password: "new_password",
        password_confirmation: "new_password",
        reset_password_token: @raw,
      } }
      user.reset_password_token = enc
      user.reset_password_sent_at = Time.current
      user.save(validate: false)
    end

    context "トークン発行から３０分" do
      it "パスワード変更が可能" do
        travel_to 30.minutes.after do
          # パスワードリセットページへアクセス
          get edit_password_path(reset_password_token: @raw)
          expect(response).to have_http_status(200)

          # パスワード変更
          put user_password_path, params: @params
          aggregate_failures do
            expect(User.first.valid_password?("new_password")).to be_truthy
            expect(response).to have_http_status(302)
            expect(response).to redirect_to mypage_path(user)
            expect(flash[:notice]).to eq "パスワードが正しく変更されました。"
          end

          # 再送信
          @params = { user: {
            password: "change_password",
            password_confirmation: "change_password",
            reset_password_token: @raw,
          } }
          put user_password_path, params: @params

          aggregate_failures do
            expect(User.first.valid_password?("change_password")).to be_falsey
            expect(flash[:alert]).to eq "すでにログインしています。"
          end
        end
      end
    end

    context "トークン発行から30分経過" do
      it "パスワード変更が不可" do
        travel_to 31.minutes.after do
          put user_password_path, params: @params
          aggregate_failures do
            expect(User.first.valid_password?("new_password")).to be_falsey
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end
end
