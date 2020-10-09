require 'rails_helper'

RSpec.describe "Users::Gunplas", type: :request do
  subject { response }

  let(:user) { create(:user) }
  let!(:gunpla) { create(:gunpla) }

  before do
    login
    url
  end

  describe "#index" do
    let(:url) { get gunplas_path }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 200 }
    end
  end

  describe "#show" do
    let(:url) { get gunpla_path(gunpla) }

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
    let(:url) { get new_gunpla_path }

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

  describe "#create" do
    let(:url) { post create_gunplas_path, params: { gunpla: attributes_for(:gunpla) } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunpla_path(Gunpla.second) }
      it "ガンプラが登録されること" do
        expect(Gunpla.count).to eq 2
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "ガンプラが登録されないこと" do
        expect(Gunpla.count).to eq 1
      end
    end
  end

  describe "#edit" do
    let(:url) { get edit_gunpla_path(gunpla) }

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

  describe "#update" do
    let(:url) { patch update_gunpla_path(gunpla), params: { gunpla: attributes_for(:gunpla) } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunpla_path(Gunpla.first) }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe "#get_category_children" do
    let(:url) { get get_category_children_gunplas_path, params: { parent_id: Category.first.id } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 401 }
      it "リクエストエラーになること" do
        expect(response.body).to include("アカウント登録もしくはログインしてください。")
      end
    end
  end

  describe "#get_category_grandchildren" do
    let(:url) { get get_category_grandchildren_gunplas_path, params: { child_id: Category.second.id } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 401 }
      it "リクエストエラーになること" do
        expect(response.body).to include("アカウント登録もしくはログインしてください。")
      end
    end
  end
end
