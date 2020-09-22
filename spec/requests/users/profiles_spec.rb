require 'rails_helper'

RSpec.describe "Users::Profiles", type: :request do
  subject { response }

  let(:user) { create(:user) }

  before do
    login
    url
  end

  describe "#show" do
    let(:url) { get users_profile_path(user) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
