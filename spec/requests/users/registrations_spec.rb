require 'rails_helper'

RSpec.describe "Users::Registrations" , type: :request do
  subject { response }

  let(:user) { create(:user) }

  # before do
  #   login
  #   url
  # end

  describe "#new" do
    before do
      login
      get new_user_registration_path
    end
  #  let(:url) { get new_user_registration_path }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it "リダイレクトされること" do
        expect(response).to have_http_status(302)
        expect(response).to redirect_to users_profile_url(user)
        expect(flash[:alert]).to eq I18n.t("devise.failure.already_authenticated")
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(200)}
    end
  end

  describe "#create" do
    def signup_params
        post user_registration_path, params: { user: {
          username: "user",
          email: "user@example.com",
          password: "password",
          password_confirmation: "password"
          }}
    end

    context "ログインユーザー" do
      # let(:login) { sign_in user }

      it "登録せずリダイレクトされること" do
        sign_in user

        expect { signup_params }.not_to change(User, :count)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to users_profile_url(user)
      end

    end

    context "未ログインユーザー" do
      # let(:login) { nil }

      it "登録されること" do
        expect { signup_params }.to change(User, :count).by(1)
        # expect(User.count).to eq 1
        # expect(response).to redirect_to signup_confirm_url

        # expect(response).to have_http_status(200)
      end
    end
  end

  describe "#edit" do
    context "ログインユーザー" do
      let(:login) { sign_in user }

    end

    context "未ログインユーザー" do
      let(:login) { nil }

    end
  end

  describe "#update" do
    context "ログインユーザー" do
      let(:login) { sign_in user }

    end

    context "未ログインユーザー" do
      let(:login) { nil }

    end
  end

  describe "#destroy" do
    context "ログインユーザー" do
      let(:login) { sign_in user }

    end

    context "未ログインユーザー" do
      let(:login) { nil }

    end
  end

  describe "#new_confirm" do
    let(:url) { get signup_confirm_path }

    context "ログインユーザー"  do
      let(:login) { sign_in user }

      it "リダイレクトされること" do
        expect(response).to have_http_status(302)
        expect(response).to redirect_to users_profile_path(user)
        expect(flash[:danger]).to eq I18n.t("devise.failure.already_authenticated")
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

    end
  end

  # describe "#confirm_back" do
  #   context "ログインユーザー" do
  #     let(:login) { sign_in user }

  #   end

  #   context "未ログインユーザー" do
  #     let(:login) { nil }

  #   end
  # end

  # describe "#edit_email" do
  #   context "ログインユーザー" do
  #     let(:login) { sign_in user }

  #   end

  #   context "未ログインユーザー" do
  #     let(:login) { nil }

  #   end
  # end

  # describe "#update_email" do
  #   context "ログインユーザー" do
  #     let(:login) { sign_in user }

  #   end

  #   context "未ログインユーザー" do
  #     let(:login) { nil }

  #   end
  # end

  # describe "#edit_password" do
  #   context "ログインユーザー" do
  #     let(:login) { sign_in user }

  #   end

  #   context "未ログインユーザー" do
  #     let(:login) { nil }

  #   end
  # end

  # describe "#update_password" do
  #   context "ログインユーザー" do
  #     let(:login) { sign_in user }

  #   end

  #   context "未ログインユーザー" do
  #     let(:login) { nil }

  #   end
  # end

  # describe "#delete_confirm" do
  #   context "ログインユーザー" do
  #     let(:login) { sign_in user }

  #   end

  #   context "未ログインユーザー" do
  #     let(:login) { nil }

  #   end
  # end

end
