# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  def facebook
    callback_from :facebook
  end

  def twitter
    callback_from :twitter
  end

  def google_oauth2
    callback_from :google
  end

  private

  def callback_from(provider)
    return redirect_to new_user_registration_url if request.env["omniauth.auth"].blank?

    provider = provider.to_s
    # find_for_oauth : app > models > user.rb
    @user = User.find_for_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: provider.capitalize)
      sign_in_and_redirect @user, event: :authentication
    else
      @user.skip_confirmation!
      @user.save!
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: provider.capitalize)
      sign_in_and_redirect @user
    end
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
