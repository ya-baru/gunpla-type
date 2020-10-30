require 'rails_helper'

RSpec.describe "Users::Rankings", type: :request do
  describe "#index" do
    subject { response }

    let!(:user) { create(:user) }

    before do
      login
      get rankings_path
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 200 }
    end
  end
end
