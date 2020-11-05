require 'rails_helper'

RSpec.describe "RailsAdmin", type: :request do
  describe "GET /admin" do
    subject { response }

    let(:admin) { create(:user, :admin) }

    before do
      login
      url
    end

    context "管理者" do
      let(:login) { sign_in admin }
      let(:url) { get rails_admin_path }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログイン" do
      let(:login) { nil }
      let(:url) { get rails_admin_path }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "管理者以外" do
      subject { -> { get rails_admin_path } }

      let(:user) { create(:user) }
      let(:login) { sign_in user }
      let(:url) { nil }

      it { is_expected.to raise_error(CanCan::AccessDenied) }
    end
  end
end
