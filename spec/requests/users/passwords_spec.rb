require 'rails_helper'

RSpec.describe "Users::Passwords", type: :request do
  let(:user) { create(:user) }

  describe "#update" do
    before do
      @raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      @params = { user: {
        password: "change_password",
        password_confirmation: "change_password",
        reset_password_token: @raw,
      } }
      user.reset_password_token = enc
      user.reset_password_sent_at = Time.current
      @user = user.save(validate: false)
    end

    context "トークン発行から２時間以内" do
      it "パスワード変更が可能" do
        travel_to 119.minutes.after do
          put user_password_path, params: @params
          expect(User.first.valid_password?("change_password")).to be_truthy
        end
      end
    end

    context "トークン発行から２時間経過" do
      it "パスワード変更が不可" do
        travel_to 121.minutes.after do
          put user_password_path, params: @params
          expect(User.first.valid_password?("change_password")).to be_falsey
        end
      end
    end
  end
end
