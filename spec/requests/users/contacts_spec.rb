require 'rails_helper'

RSpec.describe "Users::Contacts", type: :request do
  subject { response }

  let(:contact) { create(:contact) }

  before { url }

  describe "#new" do
    let(:url) { get new_user_contact_path }

    it { is_expected.to have_http_status 200 }
  end

  describe "#confirm" do
    let(:url) { post contact_confirm_path, params: { contact: attributes_for(:contact) } }

    it { is_expected.to have_http_status 200 }
  end

  describe "#create" do
    let(:url) { post user_contact_path, params: { contact: attributes_for(:contact) } }

    it { is_expected.to have_http_status 302 }
    it { is_expected.to redirect_to root_path }
    it "メール送信すること" do
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(flash[:notice]).to eq "お問い合わせを受け付けました"
    end
  end
end
