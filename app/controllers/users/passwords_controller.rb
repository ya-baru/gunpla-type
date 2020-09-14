# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  include Account
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    # account_confirmed : concerns < account.rb
    return account_confirmed unless resource.confirmed_at?

    if successfully_sent?(resource)
      redirect_to password_reset_email_url
    else
      render 'new'
    end
  end

  def password_reset_email
    return redirect_to root_path if user_signed_in?
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
