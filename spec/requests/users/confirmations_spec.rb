require 'rails_helper'

RSpec.describe "Users::Confirmations", type: :request do
  subject { response }

  let(:user) { create(:user) }

  before do
    login
    url
  end

  describe "#new" do
    let(:url) { get new_account_confirmation_path }

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
    let(:url) { post account_confirmation_path, params: { user: { email: user.email } } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to users_profile_path(user) }
      it "メール送信せずリダイレクトすること" do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end

    context "アカウント有効化ユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status(200) }
      it "メール送信しないこと" do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end

    context "アカウント未有効化ユーザー" do
      let(:login) { nil }
      let(:user) { create(:user, :unconfirmation) }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to account_confirmation_mail_sent_path }
      it "メール送信すること" do
        expect(ActionMailer::Base.deliveries.count).to eq 2
      end
    end
  end
end
