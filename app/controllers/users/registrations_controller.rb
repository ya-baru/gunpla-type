# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @user = User.new(session[:user] || {})
    session[:user] = nil
    respond_with @user
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    set_minimum_password_length

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        expire_data_after_sign_in!
        redirect_to account_confirmation_mail_sent_url
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def confirm_new
    @user = User.new(sign_up_params)

    unless @user.valid?
      session[:user] = valid_params
      redirect_to signup_url, flash: { danger: @user.errors.full_messages.join(",") }
    end
  end

  def confirm_back
    session[:user] = valid_params
    redirect_to signup_url
  end

  def mail_sent
    redirect_to root_path if user_signed_in?
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    user_url(resource)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def valid_params
    sign_up_params.select { |k, v| k == 'email' || k == 'username' }
  end
end
