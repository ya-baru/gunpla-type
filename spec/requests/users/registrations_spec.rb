require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  subject { response }

  let!(:user) { create(:user) }

  before do
    login
    url
  end

  describe "#new" do
    let(:url) { get new_user_registration_path }

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
      post user_registration_path, params: { user: attributes_for(:user) }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
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
    let(:url) { get edit_user_registration_path(user) }

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

    context "アカウント未有効化ユーザー" do
      let(:unconfirm_user) { create(:user, :unconfirmation) }
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
    end
  end

  describe "#update" do
    let(:url) do
      patch update_user_registration_path(user), params: { user: {
        username: "change_name",
        profile: "あいうえお",
      } }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
      it "正常に更新されること" do
        expect(flash[:notice]).to eq "アカウント情報を変更しました。"
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

    context "他ユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(other_user) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(
          username: "change_name",
          profile: "あいうえお"
        )
        expect(other_user.reload).to have_attributes(
          username: "change_name",
          profile: "あいうえお"
        )
      end
    end

    context "アカウント未有効化ユーザー" do
      let(:unconfirm_user) { create(:user, :unconfirmation) }
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
    end

    describe "プロフィール関連データのみ編集可能チェック" do
      let(:login) { sign_in user }

      context "email" do
        let(:url) do
          patch update_user_registration_path(user), params: { user: {
            email: "new@example.com",
            email_confirmation: "new@example.com",
          } }
        end

        it "変更されていないこと" do
          expect(user.email).not_to eq "new@example.com"
        end
      end

      context "password" do
        let(:url) do
          patch update_user_registration_path(user), params: { user: {
            password: "new-password",
            password_confirmation: "new-password",
            current_password: user.password,
          } }
        end

        it "変更されていないこと" do
          expect(user.password).not_to eq "new-password"
        end
      end

      context "admin_flg" do
        let(:url) do
          patch update_user_registration_path(user), params: { user: {
            admin_flg: true,
          } }
        end

        it "変更されていないこと" do
          expect(user.admin_flg).to be_falsey
        end
      end
    end
  end

  describe "#destroy" do
    let(:url) { delete destroy_user_registration_path(user) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to root_path }
      it "正常にユーザーが削除されること" do
        expect(User.count).to eq 0
        expect(flash[:notice]).to eq "アカウントを削除しました。またのご利用をお待ちしております。"
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
      it "指定したユーザーは削除されないこと" do
        aggregate_failures do
          expect(User.count).to eq 1
          expect(User.first.username).to eq user.username
        end
      end
    end

    context "他ユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to root_path }
      it "指定したユーザーは削除されないこと" do
        aggregate_failures do
          expect(User.count).to eq 1
          expect(User.first.username).to eq user.username
        end
      end
    end
  end

  describe "#new_confirm" do
    let(:url) { post signup_confirm_path }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to new_user_registration_path }
    end

    context "アカウント未有効化ユーザー" do
      let(:unconfirm_user) { create(:user, :unconfirmation) }
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to new_user_registration_path }
    end
  end

  describe "#edit_email" do
    let(:url) { get edit_email_user_registration_path(user) }

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

    context "OmniAuthユーザー" do
      let(:user) { create(:user, :omniauth) }
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
    end
  end

  describe "#update_email" do
    let(:url) do
      patch update_email_user_registation_path(user), params: { user: {
        email: "new@example.com",
        email_confirmation: "new@example.com",
      } }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
      it "正常に更新されること" do
        expect(user.reload).to have_attributes(email: "new@example.com")
        expect(flash[:notice]).to eq "メールアドレスが正しく変更されました。"
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(401) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(email: "new@example.com")
      end
    end

    context "他ユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(other_user) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(email: "new@example.com")
      end
    end

    context "OmniAuthユーザー" do
      let(:user) { create(:user, :omniauth) }
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(email: "new@example.com")
      end
    end

    describe "メールアドレスのみ編集可能チェック" do
      let(:login) { sign_in user }

      context "username, profile" do
        let(:url) do
          patch update_email_user_registation_path(user), params: { user: {
            usernamel: "new-user",
            profile: "あいうえお",
          } }
        end

        it "変更されていないこと" do
          aggregate_failures do
            expect(user.username).not_to eq "new-user"
            expect(user.profile).not_to eq "あいうえお"
          end
        end
      end

      context "password" do
        let(:url) do
          patch update_email_user_registation_path(user), params: { user: {
            password: "new-password",
            password_confirmation: "new-password",
            current_password: user.password,
          } }
        end

        it "変更されていないこと" do
          expect(user.password).not_to eq "new-password"
        end
      end
    end
  end

  describe "#edit_password" do
    let(:url) { get edit_password_user_registration_path }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(200) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "他ユーザーを指定" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(200) }
    end

    context "OmniAuthユーザー" do
      let(:user) { create(:user, :omniauth) }
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
    end
  end

  describe "#update_password" do
    let(:url) do
      patch update_password_user_registration_path(user), params: { user: {
        password: "new-password",
        password_confirmation: "new-password",
        current_password: "password",
      } }
    end

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
      it { is_expected.to redirect_to mypage_path(other_user) }
      it "更新されないこと" do
        expect(other_user.reload).not_to have_attributes(password: "new-password")
      end
    end

    context "OmniAuthユーザー" do
      let(:user) { create(:user, :omniauth) }
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
      it "更新されないこと" do
        expect(user.reload).not_to have_attributes(password: "new-password")
      end
    end

    describe "パスワードのみ編集可能チェック" do
      let(:login) { sign_in user }

      context "username, profile" do
        let(:url) do
          patch update_password_user_registration_path(user), params: { user: {
            usernamel: "new-user",
            profile: "あいうえお",
          } }
        end

        it "変更されていないこと" do
          expect(user.email).not_to eq "あいうえお"
        end
      end

      context "email" do
        let(:url) do
          patch update_password_user_registration_path(user), params: { user: {
            email: "new@example.com",
            email_confirmation: "new@example.com",
          } }
        end

        it "変更されていないこと" do
          expect(user.email).not_to eq "new@example.com"
        end
      end
    end
  end

  describe "#delete_confirm" do
    let(:url) { get signout_confirm_path }

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
