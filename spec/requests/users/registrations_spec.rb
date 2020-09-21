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
    before do
      login
      post user_registration_path, params: {
        user: attributes_for(:user),
      }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to users_profile_path(user) }
      it "新しく登録されないこと" do
        expect(User.count).to eq 1
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to account_confirmation_mail_sent_path }
      it "新しく登録されること" do
        expect(User.count).to eq 2
      end
    end
  end

  describe "#edit" do
    before do
      login
      get edit_user_registration_path(user)
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(200) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
    end

    context "他ユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(200) }
    end
  end

  describe "#update" do
    before do
      login
      patch update_user_registration_path(user), params: { user: {
        username: "change_name",
        profile: "あいうえお",
      } }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to users_profile_path(user) }
      it "正常に更新されること" do
        expect(user.reload).to have_attributes(
          username: "change_name",
          profile: "あいうえお"
        )
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(
          username: "change_name",
          profile: "あいうえお"
        )
      end
    end

    context "他のユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to users_profile_path(other_user) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(
          username: "change_name",
          profile: "あいうえお"
        )
      end
    end
  end

  describe "#destroy" do
    before do
      login
      delete destroy_user_registration_path(user)
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to root_path }
      it "正常にユーザーが削除されること" do
        expect(User.count).to eq 0
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
      it "削除されずリクエストエラーを返すこと" do
        expect(User.count).to eq 1
      end
    end

    context "他ユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(302) }
      it "指定したユーザーは削除されないこと" do
        expect(User.count).to eq 1
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

    context "他ユーザー" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(200) }
    end
  end

  describe "#update_email" do
    before do
      login
      patch update_email_user_registation_path(user), params: { user: {
        email: "user@example.com",
        email_confirmation: "user@example.com",
      } }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it "正常に更新されること" do
        expect(user.reload).to have_attributes(email: "user@example.com")
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(email: "user@example.com")
      end
    end

    context "他ユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(302) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(email: "user@example.com")
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

    context "他ユーザー指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(200) }
    end
  end

  describe "#update_password" do
    before do
      login
      patch update_password_user_registration_path(user), params: { user: {
        password: "new-password",
        password_confirmation: "new-password",
        current_password: "password",
      } }
    end

    # context "ログインユーザー", :focus do
    #   let(:login) { sign_in user }

    #   it "リダイレクトされること" do
    #     expect(user.reload).to have_attributes(password: "new-password")

    #     # expect(response).to have_http_status(302)
    #     # expect(response).to redirect_to users_profile_path(user)
    #   end
    # end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(password: "new-password")
      end
    end

    context "他ユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to users_profile_path(other_user) }
      it "更新されないこと" do
        expect(other_user.reload).not_to have_attributes(password: "new-password")
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
