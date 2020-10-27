require 'rails_helper'

RSpec.describe "Users::Notifications", type: :request do
  subject { response }

  before do
    login
    url
  end

  describe "#index" do
    let(:user) { create(:user) }
    let(:url) { get notifications_path }

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

  describe "#update" do
    let!(:notification) { create(:notification) }
    let(:visitor) { notification.visitor }
    let(:visited) { notification.visited }
    let(:url) { patch notification_path(notification) }

    context "ログインユーザー" do
      let(:login) { sign_in visited }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to mypage_path(visited) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
