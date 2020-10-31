require 'rails_helper'

RSpec.describe "Users::mypage", type: :request do
  subject { response }

  let(:user) { create(:user) }

  before do
    login
    url
  end

  describe "#show" do
    let(:url) { get mypage_path(user) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "存在しないユーザー" do
      let(:login) { sign_in user }
      let(:url) { get mypage_path(2) }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe "#like_reviews" do
    let(:url) { get like_reviews_mypage_path(user) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "存在しないユーザー" do
      let(:login) { sign_in user }
      let(:url) { get mypage_path(2) }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe "#favorite_gunplas" do
    let(:url) { get favorite_gunplas_mypage_path(user) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "存在しないユーザー" do
      let(:login) { sign_in user }
      let(:url) { get mypage_path(2) }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe "#following" do
    let(:url) { get following_mypage_path(user) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "存在しないユーザー" do
      let(:login) { sign_in user }
      let(:url) { get mypage_path(2) }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe "#followers" do
    let(:url) { get followers_mypage_path(user) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "存在しないユーザー" do
      let(:login) { sign_in user }
      let(:url) { get mypage_path(2) }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to root_path }
    end
  end
end
