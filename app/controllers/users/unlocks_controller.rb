# frozen_string_literal: true

class Users::UnlocksController < Devise::UnlocksController
  include Account

  # def new
  #   super
  # end

  def create
    user = User.find_by(email: resource_params[:email])
    if user.present?
      # account_confirmed : concerns/account.rb
      return account_confirmed unless user.confirmed_at?
    end

    self.resource = resource_class.send_unlock_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      redirect_to unlock_mail_sent_url
    else
      render 'new'
    end
  end

  # def show
  #   super
  # end

  def mail_sent
    redirect_to root_path if user_signed_in?
  end

  # protected

  # The path used after sending unlock password instructions
  # def after_sending_unlock_instructions_path_for(resource)
  #   super(resource)
  # end

  # The path used after unlocking the resource
  # def after_unlock_path_for(resource)
  #   super(resource)
  # end
end
