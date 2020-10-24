require 'rails_helper'

RSpec.describe "Users::Relationships", type: :request do
  subject { response }

  before do
    login
    url
  end

  describe "#create" do
    let(:follower) { create(:user) }
    let(:followed) { create(:user) }
    let(:url) { post relationships_path, params: { followed_id: followed.id } }

    context "ログインユーザー" do
      let(:login) { sign_in follower }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(follower) }
      it "カウントあり" do
        expect(follower.following.count).to eq 1
      end
    end

    context "同一ユーザー" do
      let(:login) { sign_in followed }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(followed) }
      it "カウントなし" do
        expect(followed.following.count).to eq 0
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "カウントなし" do
        expect(Relationship.count).to eq 0
      end
    end
  end

  describe "#destroy" do
    let(:relationship) { create(:relationship) }
    let(:follower) { relationship.follower }
    let(:followed) { relationship.followed }

    let(:url) { delete relationship_path(followed) }

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "カウントなし" do
        expect(Relationship.count).to eq 1
      end
    end
  end
end
