# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :OAuth_user?, only: %i(edit_email update_email edit_password update_password)
  prepend_before_action :authenticate_scope!, only: %i(
    edit update edit_email update_email edit_password update_password delete_confirm destroy
  )
  before_action :authenticate_user!, only: %i(
    edit update edit_email update_email edit_password update_password delete_confirm destroy
  )
  before_action :set_minimum_password_length, only: %i(new edit_password)

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
      return if resource.uid?
      resource.avatar.attach(account_update_params[:avatar])
    end

    if resource_updated
      flash[:notice] = I18n.t("devise.registrations.updated")
      redirect_to users_profile_url(current_user)
    else
      render :edit
    end
  end

  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    flash[:notice] = I18n.t("devise.registrations.destroyed")
    yield resource if block_given?
    redirect_to root_url
  end

  def new_confirm
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

  def edit_email; end

  def update_email
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource.attributes = account_update_params
    resource_updated = resource.save(context: :change_email)
    yield resource if block_given?

    if resource_updated
      flash[:notice] = I18n.t("devise.registrations.email_updated")
      redirect_to users_profile_url(current_user)
    else
      render :edit_email
    end
  end

  def edit_password; end

  def update_password
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      flash[:notice] = I18n.t("devise.registrations.password_updated")
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      redirect_to users_profile_url(current_user)
    else
      clean_up_passwords resource
      psassword_invalid_message
      set_minimum_password_length
      render 'edit_password'
    end
  end

  def delete_confirm; end

  protected

  def update_resource(resource, params)
    return resource.update_with_password(params) if params.key?(:password)
    resource.update_without_password(params)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

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
    redirect_to users_profile_url(current_user) if current_user.uid?
  end
end
