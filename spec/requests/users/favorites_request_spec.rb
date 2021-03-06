require 'rails_helper'

RSpec.describe "Users::Favorites", type: :request do
  subject { response }

  before do
    login
    url
  end

  describe "#create" do
    let(:user) { create(:user) }
    let(:gunpla) { create(:gunpla) }
    let(:url) { post favorites_path, params: { gunpla_id: gunpla.id } }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunpla_path(gunpla) }
      it "カウントされること" do
        expect(user.favorites.count).to eq 1
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "カウントされないこと" do
        expect(Favorite.count).to eq 0
      end
    end
  end

  describe "#destroy" do
    let!(:favorite) { create(:favorite) }
    let(:user) { favorite.user }
    let(:gunpla) { favorite.gunpla }
    let(:url) { delete favorite_path(favorite) }

    context "ログインユーザー" do
      let(:login) { sign_in user }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to gunpla_path(gunpla) }
      it "カウントされること" do
        expect(Favorite.count).to eq 0
      end
    end

    context "未ログインユーザー" do
      let(:login) { nil }

      it { is_expected.to have_http_status 302 }
      it { is_expected.to redirect_to new_user_session_path }
      it "カウントされないこと" do
        expect(Favorite.count).to eq 1
      end
    end
  end
end
