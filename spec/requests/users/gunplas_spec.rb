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

  describe "#search_index" do
    let(:url) { get search_gunplas_path, params: { q: { name_cont: "ガンダム" } } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 200 }
    end
  end

  describe "#select_category_index" do
    let!(:category) { create(:child_category) }
    let(:url) { get select_category_index_gunpla_path(category.id) }

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
    let(:url) { patch update_gunpla_path(gunpla), params: { gunpla: attributes_for(:gunpla, :update) } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunpla_path(Gunpla.first) }
      it "更新されること" do
        expect(gunpla.reload).to have_attributes(name: "ガンプラ")
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "更新されないこと" do
        expect(gunpla.reload).not_to have_attributes(name: "ガンプラ")
      end
    end
  end

  describe "#autocomplete" do
    let(:url) { get autocomplete_gunplas_path, params: { name: "GUNPLA" } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 200 }
      it "正常にJSON形式でレスポンスされること" do
        expect(response.content_type).to eq "application/json; charset=utf-8"
        expect(JSON.parse(response.body).join).to eq gunpla.name
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 200 }
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

      it { is_expected.to have_http_status 200 }
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

      it { is_expected.to have_http_status 200 }
    end
  end
end
