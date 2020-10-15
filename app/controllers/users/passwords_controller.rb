# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  include AccountConfirm

  def new
    self.resource = resource_class.new.decorate
  end

  def create
    user = User.find_by(email: resource_params[:email])
    if user.present?
      # account_confirmed: concerns/account.rb
      return account_unconfirm unless user.confirmed_at?
    end

    self.resource = resource_class.send_reset_password_instructions(resource_params).decorate
    yield resource if block_given?
    return render :new unless successfully_sent?(resource)

    redirect_to password_reset_mail_sent_url
  end

  def edit
    self.resource = resource_class.new.decorate
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params).decorate
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      respond_with resource
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
