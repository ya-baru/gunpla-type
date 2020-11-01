require 'rails_helper'

RSpec.describe "Admins::Articles", type: :request do
  subject { response }

  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:article) { create(:article) }

  before do
    login
    url
  end

  describe "#index" do
    let(:url) { get admins_articles_path }

    context "管理者" do
      let(:login) { sign_in admin }

      it { is_expected.to have_http_status 200 }
    end

    context "管理者以外" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { sign_in nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#show" do
    let(:url) { get admins_article_path(article) }

    context "管理者" do
      let(:login) { sign_in admin }

      it { is_expected.to have_http_status 200 }
    end

    context "管理者以外" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { sign_in nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#new" do
    let(:url) { get new_admins_article_path }

    context "管理者" do
      let(:login) { sign_in admin }

      it { is_expected.to have_http_status 200 }
    end

    context "管理者以外" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { sign_in nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#create" do
    let(:url) { post admins_articles_path, params: { article: attributes_for(:article) } }

    context "管理者" do
      let(:login) { sign_in admin }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to admins_article_path(Article.all[1]) }
      it "記事が投稿されること" do
        expect(Article.count).to eq 2
      end
    end

    context "管理者以外" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { sign_in nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#edit" do
    let(:url) { get edit_admins_article_path(article) }

    context "管理者" do
      let(:login) { sign_in admin }

      it { is_expected.to have_http_status 200 }
    end

    context "管理者以外" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { sign_in nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#update" do
    let(:url) { patch admins_article_path(article), params: { article: attributes_for(:article) } }

    context "管理者" do
      let(:login) { sign_in admin }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to admins_article_path(article) }
    end

    context "管理者以外" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { sign_in nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#destroy" do
    let(:url) { delete admins_article_path(article) }

    context "管理者" do
      let(:login) { sign_in admin }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to admins_articles_path }
      it "投稿が削除されること" do
        expect(Article.count).to eq 0
      end
    end

    context "管理者以外" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to mypage_path(user) }
    end

    context "未ログインユーザー" do
      let(:login) { sign_in nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
