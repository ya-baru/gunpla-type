require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  subject { response }

  let!(:user) { create(:user) }

  describe "#new" do
    before do
      login
      get new_user_registration_path
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
    context "ログインユーザー" do
      let(:user_params) { attributes_for(:user) }

      it "登録されずリダイレクトすること" do
        sign_in user

        expect  do
          post user_registration_path, params: {
            user: user_params,
          }
        end.not_to change(User, :count)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to users_profile_path(user)
      end
    end
  end

  describe "#edit" do
    before do
      login
      get edit_user_registration_path
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(200) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to new_user_session_path }
    end

    # context "他ユーザー" do
    #   let(:other_user) { create(:user) }

    #   it "リダイレクトすること" do
    #     sign_in user
    #     get edit_user_registration_path(other_user)
    #     # expect(response).to have_http_status(302)
    #     expect(response).to redirect_to users_profile_path(user)
    #   end
    # end
  end

  describe "#update" do
    def profile_params(user)
      patch update_user_registration_path(user), params: { user: {
        username: "change_name",
        profile: "あいうえお",
      } }
    end

    context "ログインユーザー" do
      it "正常に更新されること" do
        sign_in user
        profile_params(user)
        expect(user.reload).to have_attributes(
          username: "change_name",
          profile: "あいうえお"
        )
        expect(response).to have_http_status(302)
        expect(response).to redirect_to users_profile_path(user)
      end
    end

    context "未ログインユーザー" do
      it "更新されずリクエストエラーを返すこと" do
        profile_params(user)
        expect(user.reload).not_to have_attributes(
          username: "user",
          profile: "あいうえお"
        )
        expect(response).to have_http_status(401)
      end
    end

    context "他のユーザーを指定" do
      let(:first_user) { create(:user) }
      let(:other_user) { create(:user) }

      it "更新されずリダイレクトすること" do
        sign_in first_user
        profile_params(other_user)
        expect(user.reload).not_to have_attributes(
          username: "change_name",
          profile: "あいうえお"
        )
        expect(response).to have_http_status(302)
        expect(response).to redirect_to users_profile_path(first_user)
      end
    end
  end

  describe "#destroy" do
    context "ログインユーザー" do
      it "正常にユーザーが削除されること" do
        sign_in user
        expect { delete destroy_user_registration_path(user) }.to change(User, :count).by(-1)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end

    context "未ログインユーザー" do
      it "削除されずリクエストエラーを返すこと" do
        expect { delete destroy_user_registration_path(user) }.not_to change(User, :count)
        expect(response).to have_http_status(401)
      end
    end

    context "他ユーザーを指定" do
      let!(:other_user) { create(:user) }

      it "指定したユーザーは削除されないこと" do
        sign_in user
        expect { delete destroy_user_registration_path(other_user) }.to change(User, :count).by(-1)
        expect(User.first.username).to eq other_user.username
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "#new_confirm" do
    it "ログインユーザーならリダイレクトされること" do
      sign_in user
      post signup_confirm_path
      expect(response).to have_http_status(302)
    end
  end

  describe "#confirm_back" do
    it "ログインユーザーならリダイレクトされること" do
      sign_in user
      post signup_confirm_back_path
      expect(response).to have_http_status(302)
    end
  end

  describe "#edit_email" do
    before do
      login
      get edit_email_user_registration_path(user)
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(200) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
    end

    # context "他ユーザー" do

    # end
  end

  describe "#update_email" do
    def email_params(user)
      patch update_email_user_registation_path(user), params: { user: {
        email: "user@example.com",
        email_confirmation: "user@example.com",
      } }
    end

    context "ログインユーザー" do
      it "正常に更新されること" do
        sign_in user
        email_params(user)
        expect(user.reload).to have_attributes(email: "user@example.com")
        expect(response).to have_http_status(302)
      end
    end

    context "未ログインユーザー" do
      it "更新されないこと" do
        email_params(user)
        expect(user.reload).not_to have_attributes(email: "user@example.com")
        expect(response).to have_http_status(401)
      end
    end

    context "他ユーザーを指定" do
      let(:first_user) { create(:user) }
      let(:other_user) { create(:user) }

      it "更新されないこと" do
        sign_in first_user
        email_params(other_user)
        expect(user.reload).not_to have_attributes(email: "user@example.com")
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "#edit_password" do
    before do
      login
      get edit_password_user_registration_path
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(200) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to new_user_session_path }
    end

    # context "他ユーザー指定" do

    # end
  end

  describe "#update_password" do
    def password_params(user)
      patch update_password_user_registration_path(user), params: { user: {
        password: "change-password",
        password_confirmation: "change-password",
        current_password: "password",
      } }
    end

    # context "ログインユーザー" do
    #   it "リダイレクトされること" do
    #     sign_in user
    #     password_params user
    #     expect(user.reload).to have_attributes(password: "change_password")

    #     # expect(response).to have_http_status(302)
    #     # expect(response).to redirect_to users_profile_path(user)
    #   end
    # end

    context "未ログインユーザー" do
      it "更新されずリクエストエラーを返すこと" do
        password_params user
        expect(user.reload).not_to have_attributes(password: "change_password")

        expect(response).to have_http_status(401)
      end
    end

    context "他ユーザーを指定" do
      let(:first_user) { create(:user) }
      let(:other_user) { create(:user) }

      it "更新されずリダイレクトされること" do
        sign_in first_user

        password_params other_user
        expect(other_user.reload).not_to have_attributes(password: "change_password")
        expect(response).to have_http_status(302)
        expect(response).to redirect_to users_profile_path(first_user)
      end
    end
  end

  describe "#delete_confirm" do
    before do
      login
      get signout_confirm_path
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(200) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
