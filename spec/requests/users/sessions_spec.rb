require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  subject { response }

  let(:user) { create(:user) }

  before do
    login
    url
  end

  describe "#new" do
    let(:url) { get new_user_session_path }

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
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "アカウント凍結ユーザー" do
      let(:user) { create(:user, :account_lock) }
      let(:login) { nil }

      it { is_expected.to have_http_status(200) }
    end

    context "アカウント未有効化ユーザー" do
      let(:user) { create(:user, :unconfirmation) }
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#destroy" do
    let(:url) { delete destroy_user_session_path }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to root_path }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to root_path }
    end
  end
end
