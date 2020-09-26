require 'rails_helper'

RSpec.describe "Omniauth", :js, type: :system do
  describe "OmniAuthでアカウント登録とログインテスト" do
    context "facebook" do
      before do
        OmniAuth.config.mock_auth[:facebook] = nil
        Rails.application.env_config['omniauth.auth'] = set_omniauth(service: :facebook)
        visit new_user_registration_path
      end

      it "ボタンクリックでアカウントが作成される" do
        aggregate_failures do
          expect { click_on "Facebookで登録" }.to change(User, :count).by(1)
          expect(current_path).to eq users_profile_path(User.first)
          expect(page).to have_selector(".alert-success", text: "Facebook アカウントによる認証に成功しました")
        end

        sign_out User.first
        visit new_user_session_path
        aggregate_failures do
          expect { click_on "Facebookでログイン" }.not_to change(User, :count)
          expect(current_path).to eq users_profile_path(User.first)
          expect(page).to have_selector(".alert-success", text: "Facebook アカウントによる認証に成功しました")
        end
      end
    end

    context "twitter" do
      before do
        OmniAuth.config.mock_auth[:twitter] = nil
        Rails.application.env_config['omniauth.auth'] = set_omniauth(service: :twitter)
        visit new_user_registration_path
      end

      it "ボタンクリックでアカウントが作成される" do
        aggregate_failures do
          expect { click_on "Twitterで登録" }.to change(User, :count).by(1)
          expect(current_path).to eq users_profile_path(User.first)
          expect(page).to have_selector(".alert-success", text: "Twitter アカウントによる認証に成功しました")
        end

        sign_out User.first
        visit new_user_session_path
        aggregate_failures do
          expect { click_on "Twitterでログイン" }.not_to change(User, :count)
          expect(current_path).to eq users_profile_path(User.first)
          expect(page).to have_selector(".alert-success", text: "Twitter アカウントによる認証に成功しました")
        end
      end
    end

    context "google" do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = nil
        Rails.application.env_config['omniauth.auth'] = set_omniauth(service: :google_oauth2)
        visit new_user_registration_path
      end

      it "ボタンクリックでアカウントが作成される" do
        aggregate_failures do
          expect { click_on "Googleで登録" }.to change(User, :count).by(1)
          expect(current_path).to eq users_profile_path(User.first)
          expect(page).to have_selector(".alert-success", text: "Google アカウントによる認証に成功しました")
        end

        sign_out User.first
        visit new_user_session_path
        aggregate_failures do
          expect { click_on "Googleでログイン" }.not_to change(User, :count)
          expect(current_path).to eq users_profile_path(User.first)
          expect(page).to have_selector(".alert-success", text: "Google アカウントによる認証に成功しました")
        end
      end
    end
  end
end
