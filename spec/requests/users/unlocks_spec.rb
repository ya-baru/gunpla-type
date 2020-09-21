require 'rails_helper'

RSpec.describe "Users::Unlocks", type: :request do
  let(:user) { create(:user) }

  describe "#new" do
    subject { response }

    before do
      login
      get new_account_unlock_path
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
      post account_unlock_path, params: {
        user: { email: user.email },
      }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it "メール送信せずリダイレクトすること" do
        expect(ActionMailer::Base.deliveries.count).to eq 0
        expect(response).to have_http_status 302
        expect(response).to redirect_to users_profile_path(user)
      end
    end

    context "アカウント凍結ユーザー" do
      let(:login) { nil }
      let(:user) { create(:user, :account_lock) }

      it "メール送信すること" do
        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(response).to have_http_status 302
        expect(response).to redirect_to unlock_mail_sent_path
      end
    end
  end

  # describe "#show" do
  #   before do
  #     @raw, enc = Devise.token_generator.generate(User, :unlock_token)
  #     user.unlock_token = enc
  #     user.locked_at = Time.current
  #     user.save(validate: false)
  #     @user = user
  #   end

  #   context "有効なデータ" do
  #     it "正常にアクセスできること" do
  #       get unlock_url(@user, unlock_token: @raw)
  #       # expect(@user.unlock_token).to eq nil
  #       expect(response).to have_http_status 302
  #       expect(response).to redirect_to new_user_session_path
  #     end
  #   end

  #   context "無効なデータ" do
  #     context "不正ユーザー" do
  #       it "正常にアクセスできること", :focus do
  #         get unlock_url("non_user", unlock_token: @raw)
  #         expect(@user.unlock_token).not_to eq nil
  #         # expect(response).to have_http_status 200
  #         expect(response).to redirect_to new_account_unlock_path
  #       end
  #     end

  #     context "不正トークン" do
  #       it "正常にアクセスできること" do
  #         get unlock_url(@user, unlock_token: "invalid_token")
  #         expect(@user.unlock_token).not_to eq nil
  #         expect(response).to have_http_status 200
  #       end
  #     end
  #   end

  # end
end
