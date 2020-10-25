require 'rails_helper'

RSpec.describe "Users::Comments", type: :request do
  subject { response }

  let!(:review) { create(:review) }
  let(:user) { User.first }

  before do
    login
    url
  end

  describe "#create" do
    let(:url) do
      post review_comments_path(review),
           params: { comment: { content: "あいうえお", review_id: review.id } }
    end

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it "カウントあり" do
        expect(user.comments.count).to eq 1
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "カウントなし" do
        expect(Comment.count).to eq 0
      end
    end
  end

  describe "#destroy" do
    let!(:comment) { create(:comment) }
    let(:other_user) { create(:user) }
    let(:url) { delete comment_path(comment) }

    context "コメントユーザー以外" do
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status 404 }
      it "カウントなし" do
        expect(Comment.count).to eq 1
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "カウントなし" do
        expect(Comment.count).to eq 1
      end
    end
  end
end
