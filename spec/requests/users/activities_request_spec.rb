require 'rails_helper'

RSpec.describe "Users::Activities", type: :request do
  subject { response }

  before do
    login
    get activities_path
  end

  describe "#index" do
    let(:user) { create(:user) }

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
