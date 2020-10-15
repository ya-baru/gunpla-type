# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: %i(
    edit update edit_email update_email edit_password update_password delete_confirm destroy
  )
  before_action :authenticate_user!, only: %i(
    edit update edit_email update_email edit_password update_password delete_confirm destroy
  )
  before_action :OAuth_user?, only: %i(edit_email update_email edit_password update_password)
  before_action :set_minimum_password_length, only: %i(new edit_password)

  # def new
  #   super
  # end

  def create
    build_resource(sign_up_params)
    return render :new if params[:back].present?

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
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key).decorate
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    resource.avatar.attach(account_update_params[:avatar]) if account_update_params[:avatar].present?
    return render :edit unless resource_updated

    redirect_to mypage_url(current_user), notice: I18n.t("devise.registrations.updated")
  end

  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    yield resource if block_given?
    redirect_to root_url, notice: I18n.t("devise.registrations.destroyed")
  end

  def new_confirm
    return redirect_to new_user_registration_url if params[:user].blank?

    @user = User.new(sign_up_params).decorate
    render :new unless @user.valid?
  end

  def edit_email; end

  def update_email
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key).decorate
    resource.attributes = account_update_params
    resource_updated = resource.save(context: :change_email)
    yield resource if block_given?
    return render :edit_email unless resource_updated

    redirect_to mypage_url(current_user), notice: I18n.t("devise.registrations.email_updated")
  end

  def edit_password; end

  def update_password
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key).decorate
    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      redirect_to mypage_url(current_user), notice: I18n.t("devise.registrations.password_updated")
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

  def build_resource(hash = {})
    self.resource = resource_class.new_with_session(hash, session).decorate
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = send(:"current_#{resource_name}").decorate
  end

  # def valid_params
  #   sign_up_params.select { |k, v| k == 'email' || k == 'username' }
  # end

  def psassword_invalid_message
    resource.errors.add(:password, :blank)
    resource.errors.add(:password_confirmation, :blank)
  end

  def OAuth_user?
    redirect_to mypage_url(current_user) if current_user.uid?
  end
end
