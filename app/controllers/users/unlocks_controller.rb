# frozen_string_literal: true

class Users::UnlocksController < Devise::UnlocksController
  include AccountConfirm

  def new
    self.resource = resource_class.new.decorate
  end

  def create
    user = User.find_by(email: resource_params[:email])
    if user.present?
      # account_confirmed : concerns/account.rb
      return account_unconfirm unless user.confirmed_at?
    end

    self.resource = resource_class.send_unlock_instructions(resource_params).decorate
    yield resource if block_given?
    return render :new unless successfully_sent?(resource)

    redirect_to unlock_mail_sent_url
  end

  def show
    self.resource = resource_class.unlock_access_by_token(params[:unlock_token]).decorate
    yield resource if block_given?
    return render :new unless resource.errors.empty?

    redirect_to new_user_session_url, notice: I18n.t("devise.unlocks.unlocked")
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
