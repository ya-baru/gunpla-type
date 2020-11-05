require 'rails_helper'

RSpec.describe "Users::Likes", type: :request do
  subject { response }

  let!(:like) { create(:like) }
  let(:user) { like.user }
  let(:review) { like.review }
  let(:other_user) { create(:user) }

  before do
    login
    url
  end

  describe "#create" do
    let(:url) { post likes_path, params: { review_id: review.id } }

    context "ログインユーザー" do
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to review_path(review) }
      it "カウントあり" do
        expect(other_user.likes.count).to eq 1
      end
    end

    context "レビュアー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to review_path(review) }
      it "カウントなし" do
        expect(user.likes.count).to eq 1
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "カウントなし" do
        expect(Like.count).to eq 1
      end
    end
  end

  describe "#destroy" do
    let(:url) { delete like_path(like) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to review_path(review) }
      it "カウントされること" do
        expect(Favorite.count).to eq 0
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "カウントなし" do
        expect(Like.count).to eq 1
      end
    end
  end
end
