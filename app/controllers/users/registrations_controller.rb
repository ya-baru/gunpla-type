# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :OAuth_user?, only: [:edit_email, :update_email, :edit_password, :update_password]
  before_action :authenticate_scope!, only: [:edit, :update, :edit_email, :update_email, :edit_password, :update_password]
  before_action :sign_in_required, only: [:edit, :update, :edit_email, :update_email, :edit_password, :update_password, :destroy]
  before_action :set_minimum_password_length, only: [:new, :edit_password]

  def new
    @user = User.new(session[:user] || {})
    session[:user] = nil
    respond_with @user
  end

  def create
    build_resource(sign_up_params)

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

  # def edit
  #   super
  # end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if account_update_params[:avatar].present?
      resource.avatar.attach(account_update_params[:avatar])
    end

    if resource_updated
      flash[:notice] = "アカウント情報を変更しました。"
      redirect_to user_url(current_user)
    else
      render :edit
    end
  end

  def edit_email
    render :edit_email
  end

  def update_email
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource.attributes = account_update_params
    resource_updated = resource.save(context: :change_email)
    yield resource if block_given?

    if resource_updated
      flash[:notice] = "メールアドレスが正しく変更されました。"
      redirect_to user_url(current_user)
    else
      render :edit_email
    end
  end

  def edit_password
    render :edit_password
  end

  def update_password
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      flash[:notice] = "パスワードが正しく変更されました。"
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      redirect_to user_url(current_user)
    else
      clean_up_passwords resource
      psassword_invalid_message
      set_minimum_password_length
      render 'edit_password'
    end
  end

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

  def update_resource(resource, params)
    return resource.update_with_password(params) if params.key?(:password)
    resource.update_without_password(params)
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

  def psassword_invalid_message
    resource.errors.add(:password, :blank)
    resource.errors.add(:password_confirmation, :blank)
  end

  def OAuth_user?
    redirect_to user_url(current_user) if current_user.uid?
  end
end
