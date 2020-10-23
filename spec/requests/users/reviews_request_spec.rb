require 'rails_helper'

RSpec.describe "Users::Reviews", type: :request do
  subject { response }

  let!(:review) { create(:review, :with_image) }
  let(:user) { User.first }
  let(:gunpla) { Gunpla.first }

  before do
    login
    url
  end

  describe "#show" do
    let(:url) { get review_path(review) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 200 }
    end
  end

  describe "#new" do
    let(:url) { get new_gunpla_review_path(gunpla) }

    context "ログインユーザー" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status 200 }
    end

    context "レビュー済みユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunpla_path(gunpla) }
      it "フラッシュが表示されること" do
        expect(flash[:alert]).to eq "『#{gunpla.name}』はレビュー済みです"
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#create" do
    let(:url) { post review_gunplas_path(gunpla), params: { review: attributes_for(:review) } }

    context "ログインユーザー" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status 200 }
    end

    context "レビュー済みユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunpla_path(gunpla) }
      it "フラッシュが表示されること" do
        expect(flash[:alert]).to eq "『#{gunpla.name}』はレビュー済みです"
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#edit" do
    let(:url) { get edit_review_path(review) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "他ログインユーザー" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunplas_path }
      it "フラッシュが表示されること" do
        expect(flash[:alert]).to eq "レビューしたガンプラではありません"
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#update" do
    let(:url) { patch review_path(review), params: { review: attributes_for(:review) } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "他ログインユーザー" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunplas_path }
      it "フラッシュが表示されること" do
        expect(flash[:alert]).to eq "レビューしたガンプラではありません"
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  # describe "#upload_image" do
  #   let(:url) { post upload_image_reviews_path }

  #   context "ログインユーザー" do
  #     let(:login) { sign_in user }

  #     it { is_expected.to have_http_status 200 }
  #   end

  #   context "未ログインユーザー" do
  #     let(:login) { nil }

  #     it { is_expected.to have_http_status 302 }
  #     it { is_expected.to redirect_to new_user_session_path}
  #   end
  # end

  describe "#destroy" do
    let(:url) { delete review_path(review) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunpla_path(gunpla) }
    end

    context "他ログインユーザー" do
      let(:other_user) { create(:user) }
      let(:login) { sign_in other_user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunplas_path }
      it "フラッシュが表示されること" do
        expect(flash[:alert]).to eq "レビューしたガンプラではありません"
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
