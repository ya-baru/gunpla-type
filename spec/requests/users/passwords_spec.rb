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
      it { is_expected.to redirect_to users_profile_path(user) }
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
      it { is_expected.to redirect_to users_profile_path(user) }
      it "メール送信しないこと" do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to password_reset_mail_sent_path }
      it "メール送信すること" do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end
    end

    # context "アカウント未有効化ユーザー", :focus do
    #   let(:user) { create(:user, :unconfirmation) }
    #   let(:login) { nil }

    #   it "メール送信すること" do
    #     expect(ActionMailer::Base.deliveries.count).to eq 0
    #     expect(response).to have_http_status 302
    #     expect(response).to redirect_to root_path
    #   end
    # end
  end

  # describe "#edit" do
  #   before do
  #     @raw, enc = Devise.token_generator.generate(User, :reset_password_token)
  #     user.reset_password_token = enc
  #     user.reset_password_sent_at = Time.current
  #     @user = user.save(validate: false)
  #   end

  #   context "有効なデータ" do
  #     it "正常にアクセスできること" do
  #       get edit_user_password_url(@user, reset_password_token: @raw)
  #       expect(response).to have_http_status 200
  #     end
  #   end

  #   context "無効なデータ", :focus do
  #     it "リダイレクトされること" do
  #       get edit_password_url(@user, reset_password_token: "a")
  #       expect(response).to have_http_status 302
  #     end
  #   end
  # end

  describe "#update" do
    before do
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      @params = { user: {
        password: "change_password",
        password_confirmation: "change_password",
        reset_password_token: raw,
      } }
      user.reset_password_token = enc
      user.reset_password_sent_at = Time.current
      @user = user.save(validate: false)
    end

    context "トークン発行から２時間以内" do
      it "パスワード変更が可能" do
        travel_to 119.minutes.after do
          put user_password_path, params: @params
          expect(User.first.valid_password?("change_password")).to be_truthy
          expect(response).to have_http_status(302)
        end
      end
    end

    context "トークン発行から２時間経過" do
      it "パスワード変更が不可" do
        travel_to 121.minutes.after do
          put user_password_path, params: @params
          expect(User.first.valid_password?("change_password")).to be_falsey
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
